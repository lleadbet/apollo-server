# Development

## Workflow

> When in doubt, reference the `scripts` in `package.json`.

To start development, simply run `npm install` (`npm i` for short). This will install and build the project.

To run Typescript in watch mode, run `npm run watch`.

If you have [Mise](https://mise.jdx.dev/) installed, your Node and NPM versions will be configured automatically for you.

## Agent Skills

This repo ships task-scoped skills that encode the contribution process, usable
from [Claude Code](https://claude.com/claude-code), [Cursor](https://cursor.com)
(which reads `.claude/skills` natively), and [Codex](https://openai.com/codex)
(which reads `.agents/skills`). The canonical copies live under `.claude/skills`;
`.agents/skills` is a symlink to it, so there is one source of truth and no
drift. Each skill has one job and points to the next, so you invoke the one that
matches where you are:

- `$triage` - scope a raw bug report or feature idea into clear intent (a
  reproduction for bugs, plugin-vs-core for features) before any code. Useful
  for engineers, PMs, and QA.
- `$contribute` - once scoped, plan the change, keep the PR focused, apply the
  public-API/versioning policy, and check PR readiness.
- `$scaffold` - for package-facing or build-sensitive changes (new exports,
  deep imports, plugins, dual ESM/CJS layout).
- `$onboard` - a guided end-to-end first contribution that walks setup and
  delegates to the three skills above at the right steps.

These are optional aids; `CONTRIBUTING.md` and this file remain the source of
truth.

## Testing

To run tests, run `npm test` (or `npm t` for short).

Arguments can be passed to the test command using the `--` like so: `npm t -- --watch` (this runs Jest in watch mode).
Similarly, you can run specific test files by name like so: `npm t -- ApolloServer.test.ts`.

Smoke tests run separately from Jest tests. They can be run with `npm run test:smoke`. Smoke tests exist to ensure the built tarballs work properly.

## Linting, Formatting, Spelling

ESLint can be run via `npm run lint`.
Prettier can be run via `npm run prettier-fix`.
Spell checking can be run via `npm run spell-check`. Words can be added to the dictionary: [`cspell-dict.txt`](./cspell-dict.txt) or ignored with the directive: `// cspell:ignore`.

All 3 of these tools have respective VSCode extensions which can be found here:
[ESLint](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint)
[Prettier](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode)
[CSpell](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker)

Code formatting and spelling are enforced in CI; status checks will fail if these commands fail.

## Publishing

This repository is published using [https://github.com/changesets/changesets](changesets). The CHANGELOG, GitHub releases, and npm publishes are all managed by changesets via [the GitHub workflow](./.github/workflows/release-pr.yml).

A "changeset" (created by running `npx changeset`) is committed to source control for each PR in order to inform the tool what type of changes were made (patch, minor, major) with an accompanying description. A changeset is _required_ for any PR touching files under `packages` in order to pass status checks. If your PR has no effective changes to any packages, you can run `npx changeset --empty` to create an empty changeset.

When at least one changeset exists, the workflow will open and update a release PR which consumes the changesets, updates package versions, and updates the CHANGELOG. When this PR is merged, the changes will be committed, the packages will be published, and a GitHub release will be created.

> **Changeset reminder hook:** A project hook (`.claude/hooks/changeset-reminder.sh`) checks before each `git commit` whether your changes touch `packages` without a changeset, and prompts you to add one. It mirrors CI's `changeset-check` so the gap is caught locally, and an empty changeset satisfies it. The detection logic is shared; only the output format differs per agent, selected with `--format`. It is wired for [Claude Code](https://claude.com/claude-code) in `.claude/settings.json` (manage via the `/hooks` menu) and for [Cursor](https://cursor.com) in `.cursor/hooks.json`. The hook is optional tooling; remove the relevant wiring to disable it.

## Build System

Apollo Server is "dual-published", shipping with both ESM and CJS, and leverages deep imports. Combined with TypeScript, this introduces a fair amount of complexity into the build infrastructure of this repository. A few quirks to keep in mind while working in this project:

* Each dual-published package has 2 tsconfigs: one for ESM and one for CJS. These must also be referenced at the top-level in the respective esm/cjs-specific tsconfig files.
* Deep imports in the `@apollo/server` package must be listed within the `package.json` ["exports"](https://nodejs.org/api/packages.html#exports) property. It's important to note that each "exports" entry must be specifically in the order: "types", "import", "require". Both [Node](https://nodejs.org/api/packages.html#exports) and [TypeScript](https://www.typescriptlang.org/docs/handbook/esm-node.html#packagejson-exports-imports-and-self-referencing)(via [`moduleResolution: "node16"`](https://www.typescriptlang.org/tsconfig#moduleResolution)) make use of these entries.
* Additional deep imports must be represented in `server/<new-import-name>` and must contain a `package.json` file. See [`server/express4/package.json`](server/express4/package.json) for an example. This is separate from the actual source code for this new import, which should exist in `server/src/<new-import-name>`. This is used by TypeScript's CommonJS configuration (`moduleResolution: "node"`).
* Smoke tests to ensure proper builds and importability exist in the `smoke-test` directory. If new deep imports are added, they should be incorporated into the smoke tests.
