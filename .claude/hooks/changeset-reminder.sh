#!/usr/bin/env bash
# Changeset reminder hook. Reminds to add a changeset before committing changes
# under packages/, mirroring CI's `changeset-check` so the gap is caught locally
# instead of in CI. The detection logic is agent-agnostic; only the output JSON
# differs per host, selected with --format.
#
#   --format claude   Claude Code PreToolUse JSON (default). Wired in
#                     .claude/settings.json, filtered to `git commit`.
#   --format cursor   Cursor beforeShellExecution JSON. Wired in
#                     .cursor/hooks.json, matched to `git commit`.
#
# Emits an "ask" decision (a speed bump, not a wall) when packages/ is touched
# but .changeset/ has no entry. An empty changeset counts as satisfied, so
# `npx changeset --empty` remains a valid escape hatch.

format="claude"
while [ $# -gt 0 ]; do
  case "$1" in
    --format) format="$2"; shift 2 ;;
    --format=*) format="${1#*=}"; shift ;;
    *) shift ;;
  esac
done

reason="This commit includes changes under packages/ but there is no changeset in .changeset/. Run \`npx changeset\` (or \`npx changeset --empty\` if no release note is needed) first - CI's changeset-check requires it."

# Files touched: working tree + staged + untracked (porcelain), plus anything
# already committed on this branch vs origin/main. Porcelain catches new
# untracked package files that `git diff` alone would miss.
changed=$(
  {
    git status --porcelain 2>/dev/null | sed 's/^...//; s/.* -> //'
    git diff --name-only origin/main...HEAD 2>/dev/null
  } | sort -u
)

# No package changes -> nothing to enforce.
echo "$changed" | grep -q '^packages/' || exit 0

# A changeset (including an empty one) satisfies the gate.
for f in .changeset/*.md; do
  [ -e "$f" ] || continue
  case "$(basename "$f")" in
    README.md) continue ;;
  esac
  exit 0
done

# packages/ changed with no changeset -> surface a reminder in the host's format.
case "$format" in
  cursor)
    printf '{"permission":"ask","user_message":%s,"agent_message":%s}\n' \
      "\"$reason\"" "\"$reason\""
    ;;
  *)
    printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":%s}}\n' \
      "\"$reason\""
    ;;
esac
