## Writing for Humans

Pick the writing skill by the kind of text. Invoke it before drafting.

- **Technical text where ambiguity is not tolerated:** use the `simple-english` skill. This covers code specifications, code documentation, ADRs, and PR descriptions about code or software. Humans read these too, but they are a subset that needs controlled language. Apply the skill to the written text only. Do not apply its chat-reply rules to my conversation with you.
- **Everything else a human reads:** use `anthropic-skills:human-voice-by-zishan`. This covers Slack messages, emails, general notes and documents, meeting material, presentations, and posts.
- **Text for another agent** (prompts, skill files, subagent briefs, tool descriptions, machine output): use the `simple-english` skill. Never use human-voice.
- **Unsure which applies:** ask me. We refine this rule case by case.

## Audience Labels

For text that you write on my behalf in a shared place (including GitHub issues, PRs, comments, Slack, email, calendar invites, and Markdown files), also use the `audience-labels` skill. It marks each part as for humans or for agents, so humans can skip agent detail. It composes with the writing skills above and does not replace them.

I always review what you write on my behalf before you send, post, or publish it. Show me the text and wait for my approval, every time.

## Git Branches

Never use `claude` as a branch name prefix. Use conventional commit type prefixes instead: `feat/`, `fix/`, `refactor/`, `perf/`, `test/`, `docs/`, `chore/`, etc.
