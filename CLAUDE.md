# docs.origin

docs.origin is the public-facing documentation site for the Origin programming language — hand-authored static HTML/CSS with a small `main.js` for interactivity. Pages cover the language itself, downloads, community, ecosystem, and tutorials. It is meant to be hosted as a static site (GitHub Pages, Cloudflare Pages, Netlify, etc.).

## Build / Test / Lint Commands

- Install: not applicable (no build tooling — pure static assets)
- Build: none — open `index.html` in a browser, or serve the directory with any static server
- Test: not applicable
- Lint: not configured
- Dev / run: `python -m http.server 8000` (or any static server) from the repo root, then visit `http://localhost:8000/`

## Code Style Rules

- Language/version: HTML5, CSS3, vanilla ES6+ JavaScript
- Paradigm: single-page static site with one shared `styles.css` and one `main.js`
- Types: not applicable to HTML/CSS; `main.js` is plain JS
- Formatting: 4-space indentation in HTML/CSS; 4-space in JS (match existing files)
- Imports / module style: relative links to `styles.css`, `main.js`, and image assets
- Dependencies: none — no npm/CDN runtime deps are required for the site itself

## Verification Criteria

Before claiming any task done, Claude MUST:
1. Serve the directory with `python -m http.server 8000` and confirm the server starts without error.
2. Curl the served `index.html` and confirm the response includes the `<title>Welcome to Origin</title>`.
3. Validate that any new HTML page references `styles.css` and (if interactive) `main.js` via relative paths.
4. Report the exact commands run and their outcomes in the final message.
