---
name: audience-labels
description: Use when you write text that other people or agents will read in a shared place, such as a GitHub issue, PR description, PR comment, or review comment. Marks each part of the text as for humans or for agents, so a human can skip the agent detail. Use it together with simple-english and human-voice, not instead of them. Also use it when you are unsure which audience a text has.
---

# Audience Labels

Each text that you write on behalf of the user has an audience: humans, agents, or both. A reader must see the audience without reading the text. A human must never read agent detail to find out whether it matters.

Agent detail can be as long as it needs to be. Human text must be short.

Medium rules are in the section "Media". Today, the media in this section are defined.

## Review before you send

The user always reviews what you write on their behalf before it is sent. This is a hard rule.

1. Write the text to a local file or show it in chat.
2. Wait for the user to approve it.
3. Only then post, send, comment, or publish it.

Do this for every medium and every text, also for a short reply. A user approval for one text does not cover the next text.

## Core rules

These rules apply to every medium. A medium section can change how a rule is shown. It cannot remove a rule.

### The two labels

- Human label: `👤 For humans 👀`
- Agent label: `🤖 For agents: humans can skip this`
- Agent end line: `🤖 End of agent part.`

Use these words exactly. Do not translate them. Do not add other emoji.

### The two parts

1. The human part comes first. The user decides what goes in it. Do not use a template for its content. It must be short and it must make sense without the agent part.
2. A separator follows the human part. The medium decides what the separator is.
3. The agent part comes second. It can hold the investigation, the evidence, the steps taken, and any other detail that an agent needs.
4. The agent part starts with the agent label and ends with the agent end line.
5. The medium must let a human skip the agent part with the least effort. If the medium can fold text, fold the agent part.

### Posts with one audience

- Agent only: the whole text is one agent part. Do not write a human part.
- Human only and long: the text starts with the human label. Do not write an agent part.
- Human only and short: write no label. A text is short when it has 150 words or fewer, which is about 8 sentences or a 45 second read. It must also have no heading, table, or code block.
- If you are unsure whether a text is short, add the label. If the text is over the limit, use the flow in "Long text: ask first".

A text that a person wrote by hand needs no label.

### Where labels apply

Labels protect humans who might read the text. Use them only where a human other than the user can read the text. In a private conversation between the user and an agent, such as a direct message or a private session, write no labels.

### Long text: ask first

Length does not tell you the audience. It tells you when to ask. Use this flow when a draft is over 150 words, or has a heading, table, or code block.

1. Stop. Do not label the text on your own.
2. Ask the user one question: is this text for a human, for an agent, or for both?
3. In the same message, show a proposed split that the user can approve or change:
   - Human part: a short summary that you write. The user reviews it.
   - Agent part: the original text, verbatim.
4. If the user says human only, shorten the text to 150 words or fewer. If it must stay long, label it as long and human only.
5. If the user says agent only, put the whole text in the agent part. Write no human part.

This question and the review in "Review before you send" are one step. Do not ask twice.

### Verbatim text

When the user asks you to post an output as it is, for example a bug analysis, do not edit it. Put it in the agent part unchanged. Do not apply `simple-english` to it.

If you think that a rewrite in `simple-english` would make the text readable for both humans and agents, offer that rewrite. If the user accepts and the result is short enough for a human, you can drop the split and post one human text. Never rewrite without the offer.

### Writing style

Style rules apply to text that you write. They do not apply to verbatim text.

- Agent part: use the `simple-english` skill.
- Human part, technical topic: use the `simple-english` skill.
- Human part, non-technical topic: use the `anthropic-skills:human-voice-by-zishan` skill.

This is a recommendation. The user can choose another style.

Invoke the style skill before you draft the text.

## Media

### GitHub

Applies to issue bodies, PR descriptions, PR comments, and review comments. It does not apply to commit messages and PR titles. See "Both audiences, no labels".

Both parts:

````markdown
## 👤 For humans 👀

(short text that the user chose)

---

<details>
<summary><b>🤖 For agents: humans can skip this</b></summary>

(agent part, any length)

🤖 End of agent part.
</details>
````

- The human label is an H2 header. Do not use a block quote, because people use block quotes to quote other comments.
- The separator is a horizontal rule: `---`.
- The agent part is inside `<details>`, so it is folded by default. Leave one empty line after `<summary>` and one before `</details>`, or the Markdown inside does not render.

Agent only: put the whole text inside `<details>` with the agent summary and the agent end line. In a long thread, it shows as one collapsed line.

Human only and long: start with `## 👤 For humans 👀`. Add nothing else.

### Slack

Slack has no headers and no folding. Write bold as `*text*`. Never use `##` or `**`.

A Slack message is for humans by default. Short messages carry no label. The 150 word cutoff from the core rules applies.

Message to an agent in an open channel or thread, where humans can read it: write the agent label on its own first line, the message, and the agent end line on its own last line. Write no human part.

Message to an agent in a private direct message: write no labels.

Long message (over 150 words, or with a heading, table, or code block): use the flow in "Long text: ask first". Slack cannot fold, so the detail goes in a thread reply:

1. Post a short channel message. If the user said both audiences, start it with `*👤 For humans 👀*`. End it with a line that says the detail is in the thread.
2. Post the detail as a thread reply.
3. If the detail is for agents, the reply starts with `*🤖 For agents: humans can skip this*` and ends with `🤖 End of agent part.`
4. If the detail is for humans, the reply has no agent label. The line in the channel message that points to the thread is the only signal.

Review before you send applies to both messages. Show the channel message and the thread reply together.

### Email and calendar invites

Email and calendar invites are always for humans. Write no labels and no agent part, for any length. Do not add agent detail to them. If the user wants agent detail kept, put it somewhere else, such as a GitHub comment, and ask the user where.

Use the human-voice skill for non-technical text and `simple-english` for technical text. Keep the text short. If a draft is long, tell the user and offer a shorter version, because the reader is a human.

Review before you send applies. Never send an email or an invite without the approval of the user.

### Markdown files

The destination decides the rule.

Docs, ADRs, and similar files in a code or software repository, for example camunda/camunda: these are for humans and agents together. Write no labels and no split. Write the whole file with the `simple-english` skill, so that both readers understand it.

Plans, specs, and similar files that only an agent will use: the text can be verbatim. Put the agent label directly below the H1 title, as an H2 header: `## 🤖 For agents: humans can skip this`. If the file has YAML front matter, the front matter stays first, then the title, then the label. Write no end line. The end line rule is changed here: a whole-file agent document has no human text after it, so an end line has nothing to separate.

Any other Markdown file, for example personal notes or a file outside a code repository: ask the user who the file is for before you write it.

If you do not know the destination, ask.

### Both audiences, no labels

Code comments, docstrings, Javadoc, and similar text in code are for humans and agents together. Write no labels. Write the text with the `simple-english` skill.

Commit messages and PR titles are the same. Write no labels, use `simple-english`, and keep the subject line short. If agent detail must be kept, put it in the PR description with the GitHub layout, not in the commit message.

### Humans only, no labels

These are always for humans: release notes, changelogs, incident reports, postmortems, slides, meeting material, and Claude artifacts (HTML pages). Write no labels and no agent part. Use `human-voice` for non-technical text and `simple-english` for technical text.

### Agent only, no labels

These files are for agents, and readers already know it: `CLAUDE.md`, `AGENTS.md`, skill files, memory files, handoff notes between sessions, and comments or output from bots and CI. Write no labels. Write fresh text with the `simple-english` skill.

### Shared documents and tickets

- Google Docs, Confluence pages, Claude Docs documents, and Slack canvases: ask the user per document who it is for. If it is for both, use the two-part layout with the labels and the separator. The agent part cannot fold here, so it comes last under its label and ends with the end line.
- Tickets in Asana, Jira, or Linear: use the GitHub layout if the tool can fold text. If it cannot, ask the user how to apply the core rules.

### Other media

The rules for other media are not defined yet.

If the medium is not GitHub, ask the user how to apply the core rules before you write the text. Do not guess. Offer this default as a suggestion only: the human part first, a clear divider, then the agent part with its labels.

If the user answers, follow the answer for this text. Tell the user that this skill does not have a rule for that medium yet, and offer to add one.

## Self-check before you show the text

1. Does the text start with a label, or is it short and human-only?
2. Is the human part first and under about 150 words?
3. Does the agent part start with the agent label and end with the agent end line?
4. Is the agent part folded, where the medium allows it?
5. Did you show the text to the user, and did you wait for approval before you post it?
