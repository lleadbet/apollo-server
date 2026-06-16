---
name: onboard
description: Guided end-to-end first contribution for new Apollo Server engineers - set up the repo, scope a focused change, build it, test it, add a changeset, and open a PR. Use when walking a newcomer through their first change, delegating to $triage, $contribute, and $scaffold at the right steps instead of duplicating their guidance.
---

# Onboard

Use this skill to guide a new engineer through a complete first contribution to
Apollo Server, following the path a change actually takes to production. Walk
the steps in order and delegate to the specialized skills rather than repeating
their content - this keeps onboarding correct as those skills evolve.

## 1. Set Up

- Run `npm install` (`npm i`) - this installs dependencies and runs the build.
- If [Mise](https://mise.jdx.dev/) is installed, Node and npm versions are
  configured automatically.
- Use `npm run watch` to run TypeScript in watch mode while iterating.
- `CONTRIBUTING.md` and `DEVELOPMENT.md` are the human source of truth.

## 2. Scope The Change

- Use `$triage` to turn the bug report or feature idea into clear intent
  (intended vs. actual outcome and a reproduction for bugs; plugin-vs-core and
  use case for features).
- Use `$contribute` to confirm the work is reviewable, focused, and within the
  process gates (issue discussion for work over an hour or big changes).
- Only proceed from planning to implementation when `$contribute` classifies the
  work as `ready`. For `needs consensus` or `wrong repository / wrong package`,
  pause onboarding and help draft the maintainer-facing issue comment,
  implementation proposal, or upstream handoff instead.

## 3. Build

- Use `$scaffold` for any package-facing or build-sensitive change: new
  `@apollo/server` deep imports, package exports, plugins, or dual ESM/CJS
  layout.
- For smaller in-place edits, follow nearby package patterns under
  `packages/<package>/src` and idiomatic TypeScript.

## 4. Test

- Run a targeted file with `npm test -- <file>` while iterating.
- Run `npm test` before handoff.
- Run `npm run coverage` for broad runtime or public-API changes.
- Run `npm run test:smoke` for export, packaging, deep-import, or module-format
  changes.
- Bug fixes and behavior changes need a regression test in the affected
  package.

## 5. Quality Gates (Before The PR)

- Run `npm run lint`, `npm run prettier-fix`, and `npm run spell-check`. Add
  real words to `cspell-dict.txt` when spell-check flags them.
- Do not leave the adjacent words `FIX` and `ME` in files - CI rejects that
  marker.

## 6. Changeset

- Run `npx changeset` for any PR touching files under `packages`.
- Run `npx changeset --empty` when there are no effective package changes.
- See `DEVELOPMENT.md` for how changesets drive the release PR and publish flow.

## 7. Open The PR

- Keep the PR focused; avoid unrelated "while here" edits.
- Use `$contribute`'s PR Description guidance to write the body from
  `.github/PULL_REQUEST_TEMPLATE.md`, including the issue relationship,
  viability decision, public API impact, tests, changeset, and follow-ups.
- First-time contributors may need to complete the CLA.
- Check whether other web-framework integrations need the same change.
