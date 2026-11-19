# Git Commit & Centralized Logging Standards

## IMPORTANT: J:\My Drive\CLIENTS\Cares Bangladesh this is the docs folder, don't wrte docs or md file in the root

## 1. Commit Message Format
Every commit message must strictly follow this structure:
`<LogID>(<type>): <description>`

- **LogID**: The corresponding changelog ID matching the action scope (e.g. `CB01`, `SRV01`, `ADM01`, `WEB01`, `DEP01`, etc.).
- **type (4 letters max)**:
  - `feat` (New feature / capability)
  - `fix`  (Bug fix)
  - `refc` (Refactoring / code cleanup)
  - `docs` (Documentation updates)
  - `perf` (Performance improvements)
  - `chor` (Chores / dependency / build updates)
  - `styl` (Styling / CSS / theme UI changes)
  - `test` (Testing / test scripts)
  - `plan` (Planning & architecture goals)
- **description**: Clear, concise explanation of the change in sentence case.

**Examples**:
- `CB01(feat): setup core express backend routing and mongodb connection`
- `ADM01(feat): initialize react admin dashboard with vite and tailwind`
- `WEB01(fix): update nextjs storefront navigation and responsive layout`

---

## 2. No Lazy Commits
- Never make lazy, generic, or single-word commits (e.g. `up`, `fix`, `test`, `wip`, `temp`, `changes`).
- Every commit must describe the exact business or technical logic changed.

---

## 3. Centralized Logging & Plexi Docs Integration (Zero Local Docs)
- **Automatic Sync via Post-Commit Hook (`tools/commit-docs`)**: Every git commit is automatically documented and synced to Plexi Docs (`https://docs.plexihub.space`) using `node tools/commit-docs/run.mjs` via `.git/hooks/post-commit`.
- **Commit Body Structure for Plexi Docs**:
  Add trailers to the commit message:
  - `Category:` (`frontend` / `backend` / `dashboard` / `infra` / `docs` / `planning`)
  - `Why:` Context and problem statement
  - `Purpose:` Desired outcome / business value
  - Free Markdown body detailing file changes, architecture decisions, and testing notes.
  - `docs` commit: Add `Section:` (e.g. `integration`) and optional `Page:`; the commit body becomes that documentation page in Plexi Docs.
  - `plan` commit: Add `Status:` (`draft` / `active` / `done`), `Goal:`, and optional `Page:`; body becomes the Planning page.
- **Offline Safety (Queue)**: The hook ends with `|| true`, so commits are NEVER blocked. If PlexiHub is unreachable, commits are buffered in `.git/plexi-docs-queue/` and flushed automatically on subsequent commits.
- **Hook Setup**: Run `node tools/commit-docs/install.mjs` once per machine/environment.
- **NO LOCAL DOCUMENTATION OR BATCH FILES IN `Docs/` FOR LOGS**: We no longer write or maintain markdown changelogs or batch files locally.
- Refer to `Docs/00_Architecture.md` for full project layout and component breakdown.

---

## 4. Code Style, Commenting & Core Logic Guardrails
- **Arrow Functions**: Always use arrow functions (`const myFunc = () => {}`) for functional components and all custom logic/handlers. Do not use standard `function` declarations.
- **No Inline Comments**: NEVER put inline comments inside code bodies, loops, conditions, or JSX blocks. Keep internal logic clean.
- **Single-Line Preceding Function Comment Only**: Place exactly one concise, single-line relative comment on the line immediately preceding the function declaration.
- **Core Logic Verification**: Always clarify and verify with the user before modifying core architectural, multi-tenant, inventory deduction, or payment logic.

**Example**:
```javascript
// Calculates and returns total discount applied across cart items
const calculateDiscount = (items) => {
  return items.reduce((acc, item) => acc + (item.price - item.discount), 0);
};
```

---

## 5. Git Branching & Deployment Rules (STRICT — NO EXCEPTIONS)
- **Commit and push directly to `Live`**: all work (features, fixes, refactoring, docs) is committed on and pushed straight to the **`Live`** branch. No `temp`/`dev` step, no merge step.
- **Never push to `master`** and never force-push `Live`.
- **Commit and push only when the user asks.** Once asked, commit and `git push origin Live` without further confirmation.
- **Deploy source is `Live` only**: production pulls and builds from `origin/Live`.
- **NEVER run any VPS build, `docker compose up --build`, or deployment command without user instruction.** When the user says *"ডিপ্লয় দাও"*, run the deployment directly with tools instead of printing commands.
- **`make deploy` runs everything in Docker**: backend, admin, frontend and mongodb are built and run only through `docker compose -f docker-compose.prod.yml`. Never run node/npm builds directly on the VPS host.
- **Plexivia deploy notification**: `make deploy` (and `prod-deploy.sh`) ends with `scripts/deploy-notify.sh`, which records the version in Plexivia (`https://api.plexivia.com/api/deploy/bump?key=…`, target `CARES`), the same way Surokkha does. Run it alone with `make deploy-notify`. It never fails the deploy.
- **Plexivia Support Desk**: the backend proxies `/api/v1/support` to Plexivia with `PLEXIVIA_SUPPORT_KEY` from `backend/.env` (server-side only, never in the admin bundle).

---

## 6. Server Operations & Mandatory Credentials Documentation
- **Central Credentials Storage**: All server-related credentials, connection configurations, SSH keys, database URIs, API tokens, port mappings, and domain records must be documented immediately in:
  `J:\My Drive\CLIENTS\Cares Bangladesh\CREDENTIALS.md`
- **Zero Data Loss**: Whenever a new credential, service password, port, or environment variable is introduced, modified, or discovered during server operations, it must be proactively recorded in the Google Drive credentials documentation.

