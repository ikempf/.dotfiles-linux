#!/usr/bin/env bash
# Claude Code status line
input=$(cat)

python3 << 'PYEOF'
import sys, json, os, math, time

raw = os.environ.get('_STATUSLINE_INPUT', '')
# Input is passed via bash variable substitution below
PYEOF

# Pass input to Python via a temp approach using process substitution
python3 - << PYEOF
import sys, json, math

data = json.loads('''$(echo "$input" | python3 -c "import sys,json; print(json.dumps(json.load(sys.stdin)))" 2>/dev/null)''')

# ANSI helpers
RESET   = "\033[0m"
BOLD    = "\033[1m"
DIM     = "\033[2m"
# Colors
CYAN    = "\033[36m"
YELLOW  = "\033[33m"
GREEN   = "\033[32m"
BLUE    = "\033[34m"
MAGENTA = "\033[35m"
RED     = "\033[31m"
WHITE   = "\033[37m"
BRIGHT_WHITE = "\033[97m"

def c(color, text):
    return f"{color}{text}{RESET}"

def dim(text):
    return f"{DIM}{text}{RESET}"

# --- 1. Model name ---
model_id = data.get('model', {}).get('id', '')
model_display = data.get('model', {}).get('display_name', model_id)
# Prefer shorter model id if available, else display_name
model_str = model_id if model_id else model_display

# --- 2. Directory ---
cwd = (data.get('workspace', {}) or {}).get('current_dir') or data.get('cwd', '')
home = os.path.expanduser('~')
if cwd.startswith(home):
    cwd_display = '~' + cwd[len(home):]
else:
    cwd_display = cwd

# --- 3. Context window bar ---
ctx = data.get('context_window', {}) or {}
used_pct = ctx.get('used_percentage')
remaining_pct = ctx.get('remaining_percentage')

bar_str = ''
if used_pct is not None:
    filled = round(used_pct / 10)
    filled = max(0, min(10, filled))
    empty = 10 - filled
    # Color: green -> yellow -> red based on usage
    if used_pct < 50:
        bar_color = GREEN
    elif used_pct < 80:
        bar_color = YELLOW
    else:
        bar_color = RED
    bar = f"{bar_color}{'█' * filled}{DIM}{'░' * empty}{RESET}"
    bar_str = f"{bar} {bar_color}{used_pct:.0f}%{RESET}"

# --- 4. Lines of code changed ---
# Not a standard field in Claude Code JSON; check if present
lines_changed = None
stats = data.get('stats') or data.get('session_stats') or {}
if isinstance(stats, dict):
    added = stats.get('lines_added', 0) or 0
    removed = stats.get('lines_removed', 0) or 0
    if added or removed:
        lines_changed = added + removed

loc_str = ''
if lines_changed is not None:
    loc_str = c(CYAN, f"+{lines_changed}L")

# --- 5. Cost ---
cost = None
cost_fields = ['cost', 'session_cost', 'total_cost']
for f in cost_fields:
    v = data.get(f)
    if v is not None:
        cost = v
        break
# Also check nested
for key in ['stats', 'session_stats', 'billing']:
    sub = data.get(key) or {}
    if isinstance(sub, dict):
        for f in cost_fields:
            v = sub.get(f)
            if v is not None and cost is None:
                cost = v

cost_str = ''
if cost is not None:
    cost_str = c(GREEN, f"\${cost:.3f}")

# --- 6. Session duration ---
duration_str = ''
session_start = data.get('session_start') or (data.get('stats') or {}).get('session_start')
if session_start:
    import time
    elapsed = time.time() - session_start
    mins = int(elapsed // 60)
    hours = mins // 60
    mins = mins % 60
    if hours > 0:
        duration_str = c(DIM + YELLOW, f"{hours}h{mins}m")
    else:
        duration_str = c(DIM + YELLOW, f"{mins}m")

# --- 7. Waiting time ---
wait_str = ''
wait_sec = data.get('api_wait_seconds') or (data.get('stats') or {}).get('api_wait_seconds')
if wait_sec is not None:
    wm = int(wait_sec // 60)
    ws = int(wait_sec % 60)
    if wm > 0:
        wait_str = dim(f"wait:{wm}m{ws:02d}s")
    else:
        wait_str = dim(f"wait:{ws}s")

# --- 8. Rate limit (5h window) ---
rate_str = ''
rl = data.get('rate_limits') or {}
five_hour = rl.get('five_hour') or {}
five_pct = five_hour.get('used_percentage')
if five_pct is not None:
    if five_pct >= 80:
        rl_color = RED
    elif five_pct >= 50:
        rl_color = YELLOW
    else:
        rl_color = DIM + GREEN
    rate_str = f"{rl_color}5h:{five_pct:.0f}%{RESET}"

# --- Assemble ---
import os as _os
sep = f"  {DIM}|{RESET}  "

parts = []
parts.append(c(MAGENTA, model_str))
parts.append(c(CYAN, cwd_display))
if bar_str:
    parts.append(bar_str)
if loc_str:
    parts.append(loc_str)
if cost_str:
    parts.append(cost_str)
if duration_str:
    parts.append(duration_str)
if wait_str:
    parts.append(wait_str)
if rate_str:
    parts.append(rate_str)

print(sep.join(parts), end='')
PYEOF
