# Typst Thesis Template

A clean, structured Typst template for academic theses (M.Sc. / B.Sc.), designed for natural science and engineering programmes at German universities.

## Quick Start

```bash
git clone https://github.com/YOUR_USERNAME/typst_template.git "my-thesis"
cd "my-thesis"
```

Open `config.typ` and fill in your details, then compile with:

```bash
typst compile main.typ
```

Or use the [Typst VS Code extension](https://marketplace.visualstudio.com/items?itemName=myriad-dreamin.tinymist) for live preview.

---

## File Structure

```
├── main.typ              # Master document — document order is controlled here
├── config.typ            # All settings: title, author, spacing, fonts, colours
├── data.typ              # Glossary entries (abbreviations) and formula symbols
├── utils.typ             # Helper functions: gl, eq, si, header, todo, …
├── glossary_func.typ     # Renders the List of Abbreviations and Formula Symbols
├── Cover.typ             # Title page
├── items.bib             # BibTeX bibliography (APA v7)
├── chapters/
│   ├── 1_Introduction.typ
│   ├── 2_Theoretical_Framework.typ
│   ├── 3_Methodology.typ
│   ├── 4_Results.typ
│   ├── 5_Discussion.typ
│   └── 6_Conclusion.typ
└── figures/              # Place all images here; Logo.png is used in the header
```

---

## Setup Checklist

1. **`config.typ`** — fill in `university`, `program-name`, `report-title`, `supervisor-name`, `editors`, `matrikelnr`, `header-left-text`
2. **`figures/`** — add `Logo.png` (used in the running page header) and `Logo_groß.png` (used on the cover); replace with your institution's logo
3. **`data.typ`** — add your abbreviations and formula symbols
4. **`items.bib`** — add BibTeX entries as you cite sources
5. **`utils.typ`** — set `inwriting = false` before final submission to hide `#todo()` annotations and word counts

---

## Document Order

Controlled entirely by the numbered blocks in `main.typ`. To reorder a section, cut and paste its block:

| Block | Default position |
|---|---|
| FRONT · 1 · Table of Contents | Front matter |
| FRONT · 2 · List of Figures | Front matter |
| FRONT · 3 · List of Tables | Front matter |
| FRONT · 4 · List of Abbreviations & Symbols | Front matter |
| Chapters 1–6 | Main matter (arabic numbering) |
| BACK · 1 · Bibliography | Back matter |
| BACK · 2 · Appendix | Back matter |

> **Note:** The List of Abbreviations & Symbols uses `state.final()` so it can appear in front matter. Typst will emit a *"did not converge within 5 attempts"* warning — this is expected and the output is correct.

---

## Key Helper Functions

Import what you need at the top of each chapter file:

```typst
#import "../utils.typ": gap, eq, header, gl, gls, gll, glh, si, todo, silentheading
```

| Function | Usage | Output |
|---|---|---|
| `#gl("key")` | Body text | Long Form (SHORT) → SHORT |
| `#glh("key")` | **Headings only** | Always SHORT (no TOC side-effect) |
| `#gls("key")` | Inside equations | Always SHORT |
| `#gll("key")` | Mid-sentence, first intro | lowercase long form (SHORT) → SHORT |
| `#eq($...$, label: <eq:N_name>)` | Block equation | Numbered equation |
| `#si(8000, "kg")` | Value + unit | Non-breaking `8000 kg` |
| `#todo("text")` | Draft notes | Red annotation (hidden when `inwriting = false`) |

### Why `#glh()` in headings?

Typst renders heading content inside the Table of Contents before the chapter body. If you use `#gl("key")` in a heading, it fires in the TOC context and marks the key as "used" before Chapter 1 runs — so the first *real* use in a chapter body would show the short form instead of expanding. `#glh()` avoids this by never registering the key.

```typst
// CORRECT
== My Section — #glh("eu") <sec:2_my-section>

// WRONG — consumes the first-use expansion in the TOC
== My Section — #gl("eu") <sec:2_my-section>
```

---

## Abbreviation & Symbol Entries

Add to `data.typ`:

```typst
// Abbreviation
(
  key: "eu",
  short: "EU",
  long: "European Union",
  lower: "european union"   // optional — needed only for #gll()
),

// Formula symbol
(
  key: "c_nd",
  short: $C_"Nd"$,
  long: [Apparent domestic consumption of neodymium],
  unit: [t]
),
```

---

## Tables

All tables use the bookmark style (horizontal rules only, no cell borders):

```typst
#figure(
  box(width: 80%)[
    #table(
      columns: (1fr, 1fr),
      align: (left + horizon, center + horizon),
      stroke: none,
      table.hline(stroke: 1pt),
      [*Column A*], [*Column B*],
      table.hline(stroke: 0.5pt),
      [Row 1], [Value],
      table.hline(stroke: 1pt),
    )
  ],
  caption: [Caption text.],
  kind: table,
) <tab:N_short-description>
```

---

## Dependencies

- [Typst](https://typst.app) ≥ 0.13
- Package: [`wordometer:0.1.4`](https://typst.app/universe/package/wordometer) (installed automatically by the Typst compiler)
- Fonts: *Noto Sans Indic Siyaq Numbers* and *New Computer Modern Math* (both bundled with Typst)
