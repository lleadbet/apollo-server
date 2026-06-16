---
name: triage
description: Triage an Apollo Server bug report or feature idea into scoped, actionable intent before any code is written. Use when classifying a request, confirming a reproduction, deciding whether a feature belongs in core or a plugin, and applying the repository's process gates from CONTRIBUTING.md and the GitHub issue templates. Works for engineers and PM/QA partners alike.
---

# Triage

Use this skill to turn a raw bug report or feature idea into well-scoped intent
*before* writing code. Triage is shared ground for engineers, PMs, and QA: the
output is a clear problem statement and a routing decision, not a patch. Do not
write production code in this skill - hand off when the request is scoped.

## Classify The Request

Decide what kind of request this is first:

- **Bug** - something documented or intended does not work. Continue to "For
  Bugs".
- **Feature** - new behavior or API. Continue to "For Features".
- **Question / support** - usage help, not a defect. Route to the Apollo
  Discourse community or Stack Overflow rather than an issue or PR, per
  `.github/ISSUE_TEMPLATE/config.yml`.

## For Bugs

Capture the three fields the bug template and `CONTRIBUTING.md` require:

- **Intended outcome** - what the user was trying to accomplish, with related
  code.
- **Actual outcome** - what actually happened, including exact errors, logs, or
  output. Avoid non-specific phrases like "didn't work".
- **Reproduction** - a runnable repro (ideally `git clone` or a code sandbox)
  plus any non-trivial steps. See `.github/ISSUE_TEMPLATE/bug.yml`.

Confirm a reproduction exists before recommending code work; creating one often
reveals the bug lives outside Apollo Server. Small fixes (under ~20 lines) can
go straight to a PR, but a regression test is still required.

## For Features

- Search existing issues first; if one matches, point to it (👍) rather than
  opening a duplicate.
- Ask **"could this be a plugin?"** before proposing core changes. Evaluate the
  plugin API, and consider whether *expanding* the plugin API is the right home
  for the feature. This mirrors `.github/ISSUE_TEMPLATE/feature-request.md`.
- Capture the concrete use case, why existing features and the plugin API are
  unsuitable, and a flexible API sketch open to design discussion.
- Require issue consensus on intended behavior before any implementation PR.

## Process & Scope Gates

- A change should be backed by a GitHub issue (with consensus on behavior and
  plan) before code unless it is a self-contained fix with obvious intended
  behavior and a test - new features, breaking changes, big bug fixes, behavior
  a reviewer might disagree with, or work over an hour all need one
  (`CONTRIBUTING.md`, "Big PRs"). When unsure, treat it as needing an issue.
- Do not open issues automatically: ask the user to point at the existing issue,
  or help gather the details for them to file one manually.
- Flag cross-integration impact early: a fix in one web-framework integration
  (Express, Koa, Hapi, etc.) often applies to the others
  (`PULL_REQUEST_TEMPLATE.md`).
- Note that first-time contributors may need to complete the CLA.

## Handoff

Once the request is scoped:

- Use `$contribute` to plan the contribution, keep the PR focused, and check PR
  readiness.
- Use `$scaffold` when the change adds package-facing surfaces, deep imports,
  plugins, or other build-sensitive structure.
- Use `$onboard` for the full guided clone → build → test → changeset → PR path.
- Treat `CONTRIBUTING.md` and the `.github` templates as the human source of
  truth.
