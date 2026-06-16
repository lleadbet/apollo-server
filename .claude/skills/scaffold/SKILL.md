---
name: scaffold
description: Scaffold Apollo Server package-facing surfaces, deep imports, plugins, tests, docs, or build-system-sensitive changes. Use when adding a new public entrypoint, package export, server plugin, package module, smoke test, or any change that must respect Apollo Server's dual ESM/CJS publishing layout.
---

# Scaffold

Use this skill when adding or changing public package surfaces in Apollo Server.
Prefer existing package patterns over new structure.

## Choose The Surface

- Put package source under `packages/<package>/src`.
- Put server entrypoint source under `packages/server/src/<subpath>`.
- Put tests near the affected package, usually in `src/__tests__`, with
  descriptive `*.test.ts` names.
- Put user-facing docs in `docs/source` when the change affects documented
  behavior.

## Deep Imports And Exports

For a new `@apollo/server` deep import:

- Add the source under `packages/server/src/<new-import-name>`.
- Add a matching subpath entry in `packages/server/package.json` `exports`.
- Keep each export entry ordered as `types`, `import`, then `require`.
- Add `packages/server/<new-import-name>/package.json` for TypeScript CommonJS
  resolution, following existing files such as `packages/server/standalone`.
- Update smoke tests in `smoke-test` so the built tarballs prove the import is
  usable.

## Dual Publish Constraints

- Apollo Server publishes both ESM and CJS; do not assume one module format.
- Dual-published packages need ESM and CJS tsconfigs, referenced by top-level
  ESM/CJS build configs.
- Run `npm run codegen` when schema or generated GraphQL types change.
- Avoid ad hoc package layout changes unless existing package examples require
  them.

## Validation

- Run `npm run compile` for TypeScript and project reference changes.
- Run targeted tests with `npm test -- <file>` while iterating; run `npm test`
  before handoff.
- Run `npm run lint`, `npm run prettier-check`, and `npm run spell-check` for PR
  readiness.
- Run `npm run test:smoke` for export, packaging, deep-import, or module-format
  changes - smoke tests prove the built tarballs still import across ESM and
  CJS, so they are the compatibility guard for public-surface changes.
- Add a changeset for changes under `packages`, or an empty changeset when no
  release note is needed.
