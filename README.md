# docs.origin

the official documentation website for the Origin programming language. hand-authored static HTML/CSS — no framework, no build step, no npm. deliberately boring tech so the docs load instantly and anyone can edit them.

## what's here

- `index.html` — landing page (`<title>Welcome to Origin</title>`)
- `docs.html` — language reference, `tutorials.html` — guided examples
- `download.html` — installer downloads (versioned zips live under `assets/`, currently v1.7.28)
- `archives.html` — old versions, plus community/ecosystem pages
- `styles.css` + `main.js` — shared styling and a typing-effect flourish

## run it locally

```bash
python -m http.server 8000
# → http://localhost:8000/
```

deploy anywhere static (GitHub Pages, Cloudflare, Netlify, Render — it's currently on Render at docs-origin.onrender.com). when cutting an Origin release, update `download.html` versions + drop the new zip in `assets/` (the "sync from dev" workflow covers this).

## stack

HTML5, CSS3, tiny vanilla ES6. zero dependencies, on purpose.
