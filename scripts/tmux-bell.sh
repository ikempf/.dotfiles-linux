#!/bin/sh
# Write BEL to the tmux pane TTY that owns this hook process.
# Agent CLIs (Claude Code, Codex) run hooks without a controlling TTY, so a
# plain `printf '\a'` from the hook never reaches the pane. We walk up the
# PPID chain until we find a PID that matches a tmux pane_pid, then write
# BEL directly to that pane's pseudo-terminal so monitor-bell fires.

pid=$$
while [ "$pid" -gt 1 ]; do
  tty=$(tmux list-panes -aF '#{pane_pid}:#{pane_tty}' 2>/dev/null \
        | awk -F: -v p="$pid" '$1==p {print $2; exit}')
  [ -n "$tty" ] && printf '\a' > "$tty" && exit 0
  pid=$(awk '{print $4}' /proc/$pid/stat 2>/dev/null) || exit 0
  [ -z "$pid" ] && exit 0
done
