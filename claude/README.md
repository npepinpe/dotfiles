# Claude Code base configuration

This directory is a template for `~/.claude`. It holds only the files that are portable between machines. It does not hold credentials, history, plugins, or session data.

## Contents

| Path | What it is | How it reaches `~/.claude` |
|---|---|---|
| `CLAUDE.md` | Global instructions | `~/.claude/CLAUDE.md` imports it with `@dotfiles-claude/CLAUDE.md` |
| `agents/*.md` | Subagent definitions | One symbolic link per file |
| `statusline-command.sh` | Status line script. It needs `jq`. | Symbolic link |

The symbolic link `~/.claude/dotfiles-claude` points to this directory. The import path is relative to `~/.claude/CLAUDE.md`, so it is the same on every machine. Only the link target changes.

`settings.json` is not in this directory. Claude Code rewrites that file and it holds machine-specific values. Add the entries in the next section by hand.

## Prerequisites

- `DOTDIR` points to the root of this repository.
- `jq` and `npx` are installed.
- The `human-voice-by-zishan` skill is in your claude.ai account. It syncs to every machine that uses the account.

## settings.json entries

Add these keys to `~/.claude/settings.json`. Do not remove other keys.

```json
{
  "statusLine": {
    "type": "command",
    "command": "bash $HOME/.claude/statusline-command.sh"
  }
}
```

## Skills

`CLAUDE.md` names two skills.

- `simple-english` comes from [AminBlg/SimpleEnglish](https://github.com/AminBlg/SimpleEnglish). Install the skill only. Do not install the Claude Code plugin from that project. The plugin adds a session hook that changes every reply.
- `anthropic-skills:human-voice-by-zishan` syncs from your claude.ai account.

## Install by hand

```sh
S="$DOTDIR/claude"
mkdir -p ~/.claude/agents
for f in "$S"/agents/*.md; do ln -sfn "$f" ~/.claude/agents/; done
ln -sfn "$S/statusline-command.sh" ~/.claude/statusline-command.sh
ln -sfn "$S" ~/.claude/dotfiles-claude
echo "@dotfiles-claude/CLAUDE.md" >> ~/.claude/CLAUDE.md
npx skills add AminBlg/SimpleEnglish --skill simple-english -g -a claude-code -y
```

Run the `echo` line one time only. A second run adds a duplicate import.

## Install with Claude

Start Claude Code on the new machine. Paste this prompt.

```text
Install the Claude Code base configuration from the dotfiles repository.

1. Read the environment variable DOTDIR. If DOTDIR is not set, stop. Ask the user for the path.
2. Set SRC to "$DOTDIR/claude". If SRC does not exist, stop and report it.
3. Check that jq and npx are installed. If one is missing, tell the user. Do not install it.
4. Create the directory "$HOME/.claude/agents" if it does not exist.
5. For each file in "$SRC/agents", create a symbolic link with the same name in "$HOME/.claude/agents".
6. If a regular file already has that name, rename it to NAME.bak first. Tell the user.
7. Create a symbolic link "$HOME/.claude/statusline-command.sh" that points to "$SRC/statusline-command.sh". Use the same rule for an existing regular file.
8. Create a symbolic link "$HOME/.claude/dotfiles-claude" that points to SRC. If it exists and points to another path, stop. Ask the user.
9. Open "$HOME/.claude/CLAUDE.md". Create it if it does not exist.
10. Add the line "@dotfiles-claude/CLAUDE.md". If that line exists, do not add it again. Do not change other lines.
11. If the directory "$HOME/.claude/skills/simple-english" does not exist, run: npx skills add AminBlg/SimpleEnglish --skill simple-english -g -a claude-code -y
12. Do not install the Claude Code plugin from AminBlg/SimpleEnglish. Install the skill only.
13. Copy "$HOME/.claude/settings.json" to "$HOME/.claude/settings.json.bak".
14. Merge the JSON from the section "settings.json entries" in "$SRC/README.md" into settings.json. Use jq. Keep every existing key. If a key already exists with another value, stop and ask the user.
15. Show the user the diff of settings.json. Wait for approval before you save the change.
16. Report each file that you created, changed, or skipped.
17. Tell the user to start a new Claude Code session. Tell the user to run /memory and check that "dotfiles-claude/CLAUDE.md" is in the list.

Do not read, print, or copy these files: ".credentials.json", "settings.local.json", "history.jsonl". Do not run git commands in "$DOTDIR".
```
