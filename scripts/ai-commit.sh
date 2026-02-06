#!/usr/bin/env zsh

# ai-commit - Generate conventional commit messages using Claude Code
# To use this, create an alias in .zshrc like:
# alias git-ai-commit="~/path/to/ai-commit.sh"

set -e

if ! git rev-parse --is-inside-work-tree &>/dev/null; then
  echo "Error: not inside a git repository" >&2
  exit 1
fi

if ! command -v claude &>/dev/null; then
  echo "Error: Claude Code not installed" >&2
  echo "Install with: npm install -g @anthropic-ai/claude-code" >&2
  exit 1
fi

staged_diff=$(git diff --cached)
if [[ -z "$staged_diff" ]]; then
  echo "Error: no staged files. Use 'git add' first." >&2
  exit 1
fi

staged_files=$(git diff --cached --name-only)
last_commit=$(git log -1 --pretty=format:"%s" 2>/dev/null || echo "No previous commit")

prompt="Analyze this git diff and generate a conventional commit message in English.

Files staged:
$staged_files

Last commit message (for context):
$last_commit

Diff:
$staged_diff

Rules:
- Use conventional commits format: type(scope): small description
- Include body if necessary to explain the changes
- Types: feat, fix, docs, style, refactor, test, chore, perf, ci, build
- Keep the first line under 72 characters
- Be specific but concise
- Output ONLY the commit message, nothing else"

echo "Analyzing changes..."

commit_msg=$(echo "$prompt" | claude -p --output-format text 2>/dev/null)

if [[ -z "$commit_msg" ]]; then
  echo "Error: no response from Claude" >&2
  exit 1
fi

echo ""
echo "Suggested message:"
echo "─────────────────────"
echo "$commit_msg"
echo "─────────────────────"
echo ""

if command -v fzf &>/dev/null; then
  choice=$(printf "Yes - commit\nEdit - open editor\nNo - cancel" | fzf --height=5 --reverse --prompt="Use this message? ")
  case "$choice" in
  "Yes - commit")
    git commit -m "$commit_msg"
    echo "✓ Commit done"
    ;;
  "Edit - open editor")
    git commit -e -m "$commit_msg"
    ;;
  *)
    echo "Commit cancelled"
    exit 0
    ;;
  esac
else
  read "confirm?Use this message? [y/n/e(dit)]: "
  case "$confirm" in
  y | Y)
    git commit -m "$commit_msg"
    echo "✓ Commit done"
    ;;
  e | E)
    git commit -e -m "$commit_msg"
    ;;
  *)
    echo "Commit cancelled"
    exit 0
    ;;
  esac
fi
