#!/usr/bin/env python3
"""Claude Code status line renderer."""

import sys
import json
import os
import time

# ---------------------------------------------------------------------------
# ANSI color / style helpers
# ---------------------------------------------------------------------------
RESET   = "\033[0m"
DIM     = "\033[2m"
CYAN    = "\033[36m"
YELLOW  = "\033[33m"
GREEN   = "\033[32m"
MAGENTA = "\033[35m"
RED     = "\033[31m"

SEP = f"  {DIM}|{RESET}  "


def col(color: str, text: str) -> str:
    return f"{color}{text}{RESET}"


def dim(text: str) -> str:
    return f"{DIM}{text}{RESET}"


# ---------------------------------------------------------------------------
# Parse input
# ---------------------------------------------------------------------------
try:
    data = json.load(sys.stdin)
except Exception:
    sys.exit(0)

# ---------------------------------------------------------------------------
# 1. Model name
# ---------------------------------------------------------------------------
model_id      = (data.get("model") or {}).get("id", "")
model_display = (data.get("model") or {}).get("display_name", "")
model_str     = model_id if model_id else model_display

# ---------------------------------------------------------------------------
# 2. Directory
# ---------------------------------------------------------------------------
cwd  = ((data.get("workspace") or {}).get("current_dir")
        or data.get("cwd", ""))
home = os.path.expanduser("~")
cwd_display = ("~" + cwd[len(home):]) if cwd.startswith(home) else cwd

# ---------------------------------------------------------------------------
# 3. Context window bar  (10 chars wide, █ / ░)
# ---------------------------------------------------------------------------
ctx      = data.get("context_window") or {}
used_pct = ctx.get("used_percentage")

bar_str = ""
if used_pct is not None:
    filled = max(0, min(10, round(used_pct / 10)))
    empty  = 10 - filled
    if used_pct < 50:
        bar_color = GREEN
    elif used_pct < 80:
        bar_color = YELLOW
    else:
        bar_color = RED
    bar = f"{bar_color}{'█' * filled}{DIM}{'░' * empty}{RESET}"
    usage     = ctx.get("current_usage") or {}
    win_size  = ctx.get("context_window_size")
    used_tok  = (usage.get("input_tokens") or 0) + (usage.get("cache_creation_input_tokens") or 0) + (usage.get("cache_read_input_tokens") or 0)
    tok_str   = f" {dim(f'{used_tok:,}/{win_size:,}')}" if win_size else ""
    bar_str   = f"{bar} {bar_color}{used_pct:.0f}%{RESET}{tok_str}"

# ---------------------------------------------------------------------------
# 4. Lines of code changed  (cost.total_lines_added / total_lines_removed)
# ---------------------------------------------------------------------------
loc_str = ""
cost_obj = data.get("cost") or {}
added   = cost_obj.get("total_lines_added")   or 0
removed = cost_obj.get("total_lines_removed") or 0
if added or removed:
    loc_str = col(CYAN, f"+{added}-{removed}L")

# ---------------------------------------------------------------------------
# 5. Session cost  (cost.total_cost_usd)
# ---------------------------------------------------------------------------
cost_str = ""
cost_usd = cost_obj.get("total_cost_usd")
if cost_usd is not None:
    cost_str = col(GREEN, f"💲{cost_usd:.3f}")

# ---------------------------------------------------------------------------
# 6+7. Session duration / API wait time  (merged as ⏱ total/wait)
# ---------------------------------------------------------------------------
time_str = ""
total_ms = cost_obj.get("total_duration_ms")
api_ms   = cost_obj.get("total_api_duration_ms")

def fmt_ms(ms):
    total_m = int(ms // 60000)
    h, m = divmod(total_m, 60)
    s = int((ms % 60000) // 1000)
    if h > 0:
        return f"{h}h{m:02d}m"
    elif m > 0:
        return f"{m}m{s:02d}s"
    else:
        return f"{s}s"

if total_ms is not None and api_ms is not None:
    time_str = dim(f"⏱ {fmt_ms(api_ms)}/{fmt_ms(total_ms)}")
elif total_ms is not None:
    time_str = dim(f"⏱ {fmt_ms(total_ms)}")

# ---------------------------------------------------------------------------
# 8. Rate-limit usage (5-hour window)
# ---------------------------------------------------------------------------
rate_str = ""
five_pct = ((data.get("rate_limits") or {}).get("five_hour") or {}).get("used_percentage")
if five_pct is not None:
    if five_pct >= 80:
        rl_color = RED
    elif five_pct >= 50:
        rl_color = YELLOW
    else:
        rl_color = DIM + GREEN
    rate_str = f"{rl_color}5h:{five_pct:.0f}%{RESET}"

# ---------------------------------------------------------------------------
# Assemble
# ---------------------------------------------------------------------------
parts = [
    col(MAGENTA, model_str),
    col(CYAN, cwd_display),
]
if bar_str:
    parts.append(bar_str)
if loc_str:
    parts.append(loc_str)
if cost_str:
    parts.append(cost_str)
if time_str:
    parts.append(time_str)
if rate_str:
    parts.append(rate_str)

print(SEP.join(parts), end="")
