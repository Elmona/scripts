export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(
  vi-mode
  git
  history
)

# key
export FONTAWESOME_NPM_AUTH_TOKEN='FAF10A68-8D8C-421F-A103-4622114627C6'


source $ZSH/oh-my-zsh.sh

export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

export NO_UPDATE_NOTIFIER=1

alias c='claude --strict-mcp-config --mcp-config "{\"mcpServers\":{}}"'
alias c-mcp='claude'
alias ge=gemini
alias yw='yarn watch'
alias yb='yarn build'
alias e=exit
alias v=nvim
alias gstat='git status'
alias gpo='git pushup'
alias theme='source ~/.zshrc'
alias cb='node ~/code/playground/branch-helper/app.js'
alias t='tree'
alias bolagsverketTest='ssh -N -L 8888:localhost:8888 -p 44353 ec2-user@bastion.test.agoy.se'
alias python='/opt/homebrew/bin/python3.12'
alias pip='/opt/homebrew/bin/pip3.12'
alias timestamp="date '+%Y%m%d%H%M%s' | tee >(pbcopy)"

# broken
function rnd() {
 cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w $1 | head -n 1
}

# Hack to open vscode
code () { VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $* ;}

# .nvmrc Loader
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
export PATH="/usr/local/apache-maven-3.9.0/bin:$PATH"

# bun completions
[ -s "/Users/emil.n.larsson/.bun/_bun" ] && source "/Users/emil.n.larsson/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

eval "$(zoxide init zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ─── Worktree management ─────────────────────────────────────────────────────

AGOY_REPO="/Users/emil.n.larsson/code/agoy-monorepo"
AGOY_WT_DIR="/Users/emil.n.larsson/code/worktree"
AGOY_CLAUDE_PROJECTS="$HOME/.claude/projects"
AGOY_MAIN_MEMORY="$AGOY_CLAUDE_PROJECTS/-Users-emil-n-larsson-code-agoy-monorepo/memory"

function __wt_path_encode() {
  # /Users/foo/bar → -Users-foo-bar  (matches Claude project directory naming)
  echo "$1" | sed 's|/|-|g'
}

function __wt_init_memory() {
  local wt_path="$1"
  local wt_encoded
  wt_encoded=$(__wt_path_encode "$wt_path")
  local wt_memory="$AGOY_CLAUDE_PROJECTS/$wt_encoded/memory"
  if [[ -d "$AGOY_MAIN_MEMORY" ]]; then
    mkdir -p "$wt_memory"
    cp "$AGOY_MAIN_MEMORY"/*.md "$wt_memory/" 2>/dev/null
    echo "  Claude memory initialized at $wt_memory"
  fi
}

function wt() {
  local cmd="$1"
  shift

  case "$cmd" in

    new)
      # Create worktree + NEW branch (ephemeral tasks)
      # Usage: wt new <name> <branch> [base]
      local name="$1" branch="$2" base="${3:-develop}"
      local wt_path="$AGOY_WT_DIR/$name"
      [[ -z "$name" || -z "$branch" ]] && { echo "Usage: wt new <name> <branch> [base]"; return 1; }
      [[ -d "$wt_path" ]] && { echo "Worktree '$name' already exists"; return 1; }

      echo "Creating worktree '$name' with new branch '$branch' from '$base'..."
      git -C "$AGOY_REPO" worktree add -b "$branch" "$wt_path" "$base" || return 1
      zoxide add "$wt_path"
      __wt_init_memory "$wt_path"

      local today; today=$(date '+%Y-%m-%d')
      cat > "$wt_path/WORKTREE_CONTEXT.md" <<EOF
---
worktree: $name
branch: $branch
base: $base
created: $today
last_updated: $today
status: in-progress
---

# Worktree: $name

## Task
<!-- Describe the goal of this worktree -->

## Approach
<!-- High-level strategy -->

## Progress
<!-- Most recent first -->
### $today
- Started worktree

## Decisions made

## Dead ends / things that didn't work

## Blocked on / open questions

## Files changed (notable)

## Definition of done
EOF

      echo ""
      echo "Ready. Navigate with: z $name"
      ;;

    add)
      # Create worktree on an EXISTING branch (persistent worktrees like 'review')
      # Usage: wt add <name> <existing-branch>
      local name="$1" branch="$2"
      local wt_path="$AGOY_WT_DIR/$name"
      [[ -z "$name" || -z "$branch" ]] && { echo "Usage: wt add <name> <existing-branch>"; return 1; }
      [[ -d "$wt_path" ]] && { echo "Worktree '$name' already exists"; return 1; }

      echo "Creating worktree '$name' on existing branch '$branch'..."
      git -C "$AGOY_REPO" worktree add "$wt_path" "$branch" || return 1
      zoxide add "$wt_path"
      __wt_init_memory "$wt_path"
      echo "Ready. Navigate with: z $name"
      ;;

    switch)
      # Switch branch in an existing worktree
      # Usage: wt switch <name> <branch>
      local name="$1" branch="$2"
      local wt_path="$AGOY_WT_DIR/$name"
      [[ -z "$name" || -z "$branch" ]] && { echo "Usage: wt switch <name> <branch>"; return 1; }
      [[ ! -d "$wt_path" ]] && { echo "Worktree '$name' not found at $wt_path"; return 1; }

      git -C "$wt_path" switch "$branch" || return 1
      echo "Switched '$name' to branch '$branch'"
      ;;

    rm)
      # Remove worktree; prompts before branch + memory deletion
      # Usage: wt rm <name> [--keep-branch]
      local name="$1" keep_branch="$2"
      local wt_path="$AGOY_WT_DIR/$name"
      [[ -z "$name" ]] && { echo "Usage: wt rm <name> [--keep-branch]"; return 1; }
      [[ ! -d "$wt_path" ]] && { echo "Worktree '$name' not found at $wt_path"; return 1; }

      local branch
      branch=$(git -C "$wt_path" branch --show-current 2>/dev/null)

      git -C "$AGOY_REPO" worktree remove "$wt_path" 2>/dev/null || {
        echo "Worktree has uncommitted changes. Force remove? [y/N]"
        read -r confirm
        [[ "$confirm" =~ ^[Yy]$ ]] || return 1
        git -C "$AGOY_REPO" worktree remove --force "$wt_path" || return 1
      }

      zoxide remove "$wt_path" 2>/dev/null

      if [[ -n "$branch" && "$keep_branch" != "--keep-branch" ]]; then
        echo "Delete branch '$branch'? [y/N]"
        read -r confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
          git -C "$AGOY_REPO" branch -d "$branch" 2>/dev/null || {
            echo "Branch not fully merged. Force delete? [y/N]"
            read -r confirm2
            [[ "$confirm2" =~ ^[Yy]$ ]] && git -C "$AGOY_REPO" branch -D "$branch"
          }
        fi
      fi

      local wt_encoded; wt_encoded=$(__wt_path_encode "$wt_path")
      local wt_memory="$AGOY_CLAUDE_PROJECTS/$wt_encoded/memory"
      if [[ -d "$wt_memory" ]]; then
        echo "Remove Claude memory for '$name'? [y/N]"
        read -r confirm
        [[ "$confirm" =~ ^[Yy]$ ]] && rm -rf "$wt_memory" && echo "  Memory removed."
      fi

      echo "Worktree '$name' removed."
      ;;

    sync-memory)
      # Push updated main repo memory files to all worktrees
      [[ ! -d "$AGOY_MAIN_MEMORY" ]] && { echo "No main memory at $AGOY_MAIN_MEMORY"; return 1; }
      for wt_path in "$AGOY_WT_DIR"/*/; do
        wt_path="${wt_path%/}"
        local wt_encoded; wt_encoded=$(__wt_path_encode "$wt_path")
        local wt_memory="$AGOY_CLAUDE_PROJECTS/$wt_encoded/memory"
        if [[ -d "$wt_memory" ]]; then
          cp "$AGOY_MAIN_MEMORY"/*.md "$wt_memory/" 2>/dev/null
          echo "Synced → $wt_path"
        fi
      done
      ;;

    ls)
      git -C "$AGOY_REPO" worktree list
      ;;

    *)
      echo "Usage: wt <command>"
      echo "  wt new <name> <branch> [base]   Create worktree + new branch (ephemeral)"
      echo "  wt add <name> <branch>          Create worktree on existing branch (persistent)"
      echo "  wt switch <name> <branch>       Switch branch in existing worktree"
      echo "  wt rm <name> [--keep-branch]    Remove worktree (prompts on branch + memory)"
      echo "  wt ls                           List all worktrees"
      echo "  wt sync-memory                  Sync main repo Claude memory to all worktrees"
      ;;
  esac
}

# Created by `pipx` on 2026-04-18 11:01:19
export PATH="$PATH:/Users/emil.n.larsson/.local/bin"
