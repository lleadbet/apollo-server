# Repository Guidelines

## Project Structure & Module Organization

Apollo Server is a TypeScript npm workspace monorepo. Package code lives under
`packages/*`, with the main server implementation in `packages/server/src` and
package tests in `src/__tests__`. Documentation lives in `docs/source`, build
helpers in `scripts`, and tarball/runtime checks in `smoke-test`.

The project is developed on GitHub at `lleadbet/apollo-server`. Throughout
this file and the repo-local skills, "issue" means a GitHub issue and "PR" means
a GitHub pull request on that repository.

LLM task guidance is split into repo-local skills: `contribute`, `scaffold`,
`triage`, and `onboard`. The canonical copies live under `.claude/skills` (read
by Claude Code and Cursor); `.agents/skills` is a symlink to it for Codex, so
there is one source of truth.

## Build, Test, and Development Commands

- `npm install`: install dependencies and run setup/build hooks.
- `npm run compile`: build TypeScript project references.
- `npm run watch`: run TypeScript in watch mode.
- `npm test`: compile, then run all Jest package projects.
- `npm test -- <file>`: run a targeted Jest file while iterating.
- `npm run test:smoke`: verify built tarballs and module importability.
- `npm run lint`, `npm run prettier-check`, `npm run spell-check`: run CI-style
  quality checks.

## Coding Style & Naming Conventions

Use TypeScript and follow nearby package patterns. Formatting is 2-space
indentation, LF line endings, final newlines, single quotes, and trailing commas,
as configured by `.editorconfig` and `.prettierrc.json5`. Use `PascalCase` for
types/classes, `camelCase` for functions and variables, and descriptive
`*.test.ts` names.

## Testing & CI Expectations

Bug fixes and behavior changes need regression tests in the affected package.
Run `npm test` before handoff; use `npm run coverage` for broad runtime or public
API changes. Run `npm run test:smoke` for package exports, deep imports,
packaging, or module-format changes. CI also enforces Prettier, linting, spelling,
and rejects the adjacent words `FIX` and `ME`.

## Public API & Versioning

Apollo Server is a published library that follows semantic versioning. Treat
package `exports`, deep imports, exported functions, classes, and TypeScript
types, and documented plugin hooks as a public API contract. Default to
backwards-compatible changes and map each change to its changeset bump: patch
(compatible fix), minor (additive), major (breaking). A breaking change needs
prior issue consensus plus a rationale, migration path, and deprecation
timeline. See `CONTRIBUTING.md` for the full policy.

## Commit & Pull Request Guidelines

Keep PRs focused and avoid unrelated "while here" edits. Work likely to take
more than an hour, new features, and big bug fixes should be discussed in an
issue first, with consensus on intended behavior and implementation plan. Feature
work should consider whether the plugin API can solve the use case. PRs touching
`packages` require `npx changeset`, or `npx changeset --empty` when no package
release note is needed. A project hook
(`.claude/hooks/changeset-reminder.sh`, wired for Claude Code and Cursor)
reminds you before committing `packages` changes without a changeset; see
`DEVELOPMENT.md`.

## Agent-Specific Instructions

Use `$contribute` for contribution planning, PR readiness, and review scope.
Use `$scaffold` when adding package-facing surfaces, deep imports, plugins, tests,
docs, or other build-sensitive structure. Use `$triage` to scope a bug report or
feature idea into clear intent before writing code. Use `$onboard` for a guided
first contribution that walks setup, scoping, build, test, changeset, and PR.
Treat `CONTRIBUTING.md` and `DEVELOPMENT.md` as the human source of truth.
