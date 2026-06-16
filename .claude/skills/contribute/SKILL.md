---
name: contribute
description: Plan, triage, review, or prepare Apollo Server contributions. Use when scoping a bug fix or feature, deciding whether issue consensus is needed, preparing a pull request, reviewing contribution readiness, or applying repository contribution rules from CONTRIBUTING.md, DEVELOPMENT.md, and GitHub templates.
---

# Contribute

Use this skill to keep Apollo Server work scoped, reviewable, and aligned with
the contribution process.

## Start From Scoped Intent

Before planning a contribution, the request should already be scoped: a clear
problem statement, a reproduction for bugs, and a plugin-vs-core decision for
features. Use `$triage` to produce that if it hasn't been done. This skill takes
over once the work is scoped.

**Decide whether the change needs a tracking issue before code is written.** A
change can go straight to a PR only when it is a self-contained fix whose
intended behavior is obvious and that comes with a test (the canonical case is a
bug fix under ~20 lines). Otherwise - a new feature, a breaking change, a big
bug fix, behavior a reviewer might disagree with, or work likely to take an
engineer more than an hour - it should be backed by a GitHub issue with
consensus on intended behavior and approach first (CONTRIBUTING.md, "Big PRs").
When unsure, treat it as needing an issue; a tracked issue is cheaper than a
rejected PR, and it gives PMs and others visibility into work that PRs alone do
not.

Do not open the issue automatically. Default to asking the user to point at the
existing issue this work tracks. If none exists, help the user gather the
details (problem statement, reproduction or use case, intended behavior) and
hand that back for them to file manually - keep a human in the loop on issue
creation.

## Public API & Compatibility

Apollo Server is a published library that follows semantic versioning. Treat the
public API as a contract: package `exports` and deep imports, exported
functions, classes, and TypeScript types, and documented plugin hooks.

- Default to backwards-compatible changes; prefer additive APIs over breaking
  ones wherever a compatible design is reasonable.
- Map the change to the changeset bump deliberately: patch (compatible fix),
  minor (additive/backwards-compatible), major (breaking public API change).
- Check exported TypeScript type signatures for compatibility - a changed type
  can break consumers even when no runtime test fails.
- A breaking change requires the extra process above: issue discussion and
  consensus first, and justify it with rationale (why it can't be additive), a
  migration path, and a deprecation timeline (ship the new path, deprecate the
  old with a warning, remove only in a future major). See `CONTRIBUTING.md`.

## Keep Pull Requests Focused

- Avoid unrelated formatting, opportunistic refactors, and "while here" edits.
- Split dependent patches when possible so only one reviewable PR is open at a
  time.
- Check whether similar web-framework integrations or package surfaces are also
  affected.
- Self-review before handoff, mirroring the reviewer checklist: simplest
  approach that works (no over-general solutions), focused scope with no
  unrelated changes, tests that pin the behavior and exercise significant code
  paths, specific and correct TypeScript types, and self-documenting code.

## PR Viability First

Before preparing, pushing, or opening a PR, decide whether this PR should exist
in this repository.

Classify the work as one of:

- **ready** - the issue still describes an unresolved problem in this repo, the
  proposed fix belongs here, the implementation matches the issue intent, and no
  extra maintainer consensus is needed before review.
- **needs consensus** - the implementation is plausible but changes install
  behavior, public behavior, release process, package ownership boundaries, or
  otherwise goes beyond the issue's agreed intent. Do not open the PR yet; draft
  an issue comment or PR plan asking maintainers to confirm the approach.
- **wrong repository / wrong package** - the observed problem is caused by an
  upstream dependency, generated artifact, release state, or another package.
  Route the work to the owning repo/package and summarize the local findings.

Ask specifically:

- Has the linked issue already been fixed by a merged PR or release?
- Does the remaining user pain belong to this repo, or to an upstream package?
- Is this a durable fix, or a workaround that compensates for another artifact?
- Does the change add install-time or runtime behavior, such as `postinstall`?
  Treat install lifecycle changes as compatibility-relevant even when exports
  and TypeScript types do not change.
- Should the PR close the issue, reference it, or avoid linking it as a fix?

Only continue to PR readiness for `ready` work. For `needs consensus`, prepare
the maintainer-facing comment or plan instead. For `wrong repository / wrong
package`, prepare the upstream issue or PR summary instead.

## PR Readiness

- Link related issues and describe the behavior change at a high level. Use
  `Closes #issue` only when the PR actually resolves the tracked issue;
  otherwise use `Refs #issue` or explain the relationship.
- Add or update tests for new behavior and bug fixes; a bug fix should include
  a regression test that fails before the fix and passes after.
- Run `npm run coverage` when the change adds or changes exported public API
  surface, and `npm run test:smoke` for export, packaging, deep-import, or
  module-format changes - smoke tests are the library's compatibility guard.
- Ensure CI-relevant checks pass: tests, lint, Prettier, spelling, and any
  package-specific checks.
- Do not leave the adjacent words `FIX` and `ME` in files; CI rejects that
  marker.
- Add `npx changeset` for PRs touching `packages`, or `npx changeset --empty`
  when no package release note is needed.
- Remember that first-time contributors may need to complete the CLA.

## PR Description

When preparing or opening a PR, write the body from the repository's
`.github/PULL_REQUEST_TEMPLATE.md` and make reviewer-relevant decisions explicit:

- **Issue relationship** - link the issue and state whether the PR closes it,
  references it, or implements one part of a larger plan.
- **Viability classification** - summarize why the work was `ready`; if it was
  previously `needs consensus`, link or quote the maintainer decision that
  unblocked implementation.
- **Public API and compatibility** - call out package exports, deep imports,
  TypeScript types, plugin hooks, install lifecycle scripts, semver bump, and
  migration/deprecation notes when relevant.
- **Tests and validation** - list targeted tests and CI-style checks run, and
  explain any skipped tests or remaining manual verification.
- **Changeset** - name the changeset decision (`patch`, `minor`, `major`, or
  empty) and which packages are affected.
- **Follow-ups and ownership** - note cross-package, cross-repo, release, docs,
  or DevOps follow-ups so reviewers can tell what is intentionally out of scope.
