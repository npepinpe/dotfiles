#!/usr/bin/env bash
# Claude Code status line - mirrors the Starship prompt's elements and glyph set.
#
# Nerd Font icons are written as printf \u escapes rather than literal characters:
# they live in the Private Use Area, where a literal byte is invisible in a diff and
# easily mangled by an editor or a pipe. GLYPH names below are Nerd Font names, and
# every codepoint was checked against JetBrainsMono Nerd Font's charset.
input=$(cat)

# ---------------------------------------------------------------- glyphs
G_DIR=$(printf '\uf07c')     # nf-fa-folder_open
G_GIT=$(printf '\ue0a0')     # nf-pl-branch
G_MODEL=$(printf '\uf0e7')   # nf-fa-bolt
G_CTX=$(printf '\uf012')     # nf-fa-signal
G_TOK=$(printf '\uf1c0')     # nf-fa-database
G_CACHE=$(printf '\uf0c7')   # nf-fa-save
G_5H=$(printf '\uf017')      # nf-fa-clock_o
G_7D=$(printf '\uf1da')      # nf-fa-history
METER_ON=$(printf '▰')   # ▰ (base font, not PUA)
METER_OFF=$(printf '▱')  # ▱

# ---------------------------------------------------------------- input
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
model=$(echo "$input" | jq -r '.model.display_name // empty')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
tok_used=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')
tok_size=$(echo "$input" | jq -r '.context_window.context_window_size // empty')
five_hour=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
seven_day=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
cache_read=$(echo "$input" | jq -r '.context_window.current_usage.cache_read_input_tokens // empty')
cache_creation=$(echo "$input" | jq -r '.context_window.current_usage.cache_creation_input_tokens // empty')
cache_input=$(echo "$input" | jq -r '.context_window.current_usage.input_tokens // empty')

# Truncate directory to last 3 segments (matches starship truncation_length=3)
short_dir=$(echo "$cwd" | awk -F'/' '{
  n=NF; start=n-2; if(start<1) start=1;
  out="";
  for(i=start;i<=n;i++) { if(out!="") out=out"/"; out=out$i }
  print out
}')

# Git branch (skip optional lock to avoid blocking)
git_branch=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  git_branch=$(GIT_OPTIONAL_LOCKS=0 git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
fi

# Format token count as e.g. "42k" or "1.2M"
fmt_tokens() {
  local n=$1
  if [ "$n" -ge 1000000 ]; then
    awk "BEGIN{printf \"%.1fM\", $n/1000000}"
  elif [ "$n" -ge 1000 ]; then
    awk "BEGIN{printf \"%.0fk\", $n/1000}"
  else
    echo "$n"
  fi
}

# A 6-cell bar. Rounds up, so any non-zero usage lights at least one cell - a
# completely empty meter should mean "nothing used", not "a little bit used".
meter() {
  local pct=$1 cells=6 filled i out=""
  filled=$(awk "BEGIN{v=int($pct*$cells/100 + 0.999); if(v>$cells) v=$cells; if(v<0) v=0; print v}")
  for ((i=0; i<cells; i++)); do
    if [ "$i" -lt "$filled" ]; then out="$out$METER_ON"; else out="$out$METER_OFF"; fi
  done
  printf '%s' "$out"
}

# 32=green 33=yellow 31=red, by ascending badness
sev_color() {
  local pct=$1 warn=$2 crit=$3
  if [ "$pct" -ge "$crit" ] 2>/dev/null; then echo 31
  elif [ "$pct" -ge "$warn" ] 2>/dev/null; then echo 33
  else echo 32; fi
}

# ---------------------------------------------------------------- build
parts=$(printf '\033[34m%s %s\033[0m' "$G_DIR" "$short_dir")

if [ -n "$git_branch" ]; then
  parts="$parts $(printf '\033[35m%s %s\033[0m' "$G_GIT" "$git_branch")"
fi

if [ -n "$model" ]; then
  parts="$parts $(printf '\033[36m%s %s\033[0m' "$G_MODEL" "$model")"
fi

# Context usage: percentage plus a meter, coloured as it fills up
if [ -n "$used" ]; then
  pct=$(printf '%.0f' "$used")
  c=$(sev_color "$pct" 60 85)
  parts="$parts $(printf '\033[%sm%s %s%% %s\033[0m' "$c" "$G_CTX" "$pct" "$(meter "$pct")")"
fi

# Session token count (only when non-zero)
if [ -n "$tok_used" ] && [ "$tok_used" -gt 0 ] 2>/dev/null; then
  used_fmt=$(fmt_tokens "$tok_used")
  if [ -n "$tok_size" ] && [ "$tok_size" -gt 0 ] 2>/dev/null; then
    size_fmt=$(fmt_tokens "$tok_size")
    parts="$parts $(printf '\033[32m%s %s/%s\033[0m' "$G_TOK" "$used_fmt" "$size_fmt")"
  else
    parts="$parts $(printf '\033[32m%s %s\033[0m' "$G_TOK" "$used_fmt")"
  fi
fi

# Prompt-cache hit rate for the last API call (omit if current_usage is null,
# e.g. before the first call or right after /compact). Here a HIGH number is
# good, so the severity scale is inverted relative to the others.
if [ -n "$cache_read" ] && [ -n "$cache_creation" ] && [ -n "$cache_input" ] \
  && [ "$cache_read" -ge 0 ] 2>/dev/null && [ "$cache_creation" -ge 0 ] 2>/dev/null && [ "$cache_input" -ge 0 ] 2>/dev/null; then
  cache_denom=$((cache_read + cache_creation + cache_input))
  if [ "$cache_denom" -gt 0 ] 2>/dev/null; then
    cache_rate=$(awk "BEGIN{printf \"%.0f\", $cache_read/$cache_denom*100}")
    cache_creation_fmt=$(fmt_tokens "$cache_creation")
    if [ "$cache_rate" -ge 90 ] 2>/dev/null; then c=32
    elif [ "$cache_rate" -ge 50 ] 2>/dev/null; then c=33
    else c=31; fi
    parts="$parts $(printf '\033[%sm%s %s%% +%s\033[0m' "$c" "$G_CACHE" "$cache_rate" "$cache_creation_fmt")"
  fi
fi

# Claude.ai subscription rate-limit usage (rolling-window budget proxy)
if [ -n "$five_hour" ]; then
  pct=$(printf '%.0f' "$five_hour")
  c=$(sev_color "$pct" 60 85)
  parts="$parts $(printf '\033[%sm%s %s%%\033[0m' "$c" "$G_5H" "$pct")"
fi
if [ -n "$seven_day" ]; then
  pct=$(printf '%.0f' "$seven_day")
  c=$(sev_color "$pct" 60 85)
  parts="$parts $(printf '\033[%sm%s %s%%\033[0m' "$c" "$G_7D" "$pct")"
fi

printf '%s' "$parts"
