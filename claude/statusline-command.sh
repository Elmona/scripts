#!/usr/bin/env zsh
# Claude Code status line — git branch + dirty state + time
# Safe to run inside and outside git repos.

input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')

time_part=$(date +%H:%M)

git_part=""
if git -C "${cwd:-.}" rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(git -C "${cwd:-.}" symbolic-ref --short HEAD 2>/dev/null \
           || git -C "${cwd:-.}" rev-parse --short HEAD 2>/dev/null)
  # Skip the lock check — git status itself is read-only
  if [ -n "$(git -C "${cwd:-.}" status --porcelain 2>/dev/null)" ]; then
    dirty="*"
  else
    dirty=""
  fi
  git_part=" | ${branch}${dirty}"
fi

printf "%s%s" "$time_part" "$git_part"
