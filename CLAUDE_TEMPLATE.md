# Typst Thesis Template — Claude Instructions

This file documents the mechanics of the Typst thesis template so that Claude can assist efficiently in any project using it. Copy this file to any new project using this template and add project-specific rules below the divider at the bottom.

---

## File structure

```
Project/
├── main.typ            ← Master document — includes all chapters, sets page layout
├── config.typ          ← All typography, spacing, and cover-text configuration
├── utils.typ           ← All helper functions (import from here in every chapter)
├── data.typ            ← Glossary entries and formula symbols
├── items.bib           ← BibTeX bibliography (APA 7 style)
├── chapters/           ← English chapter files (1_Introduction.typ … 6_Conclusion.typ)
├── kapitel/            ← German chapter files (mirror of chapters/, toggled via config.typ)
├── figures/            ← All image assets (PNG, SVG …)
│   └── Logo.png        ← University logo used in the running header
├── expose/             ← Archived exposé versions (not compiled by default)
└── knowledge/
    └── graph.mmd       ← Mermaid knowledge graph (open with "Mermaid Preview")
```

**Language toggle:** `config.typ` contains `#let german = false`. Setting it to `true` switches `main.typ` to include files from `kapitel/` instead of `chapters/`.

---

## Configuration (config.typ)

All project-wide settings live in `config.typ`. Never hard-code values for these in chapter files.

| Variable | Purpose |
|----------|---------|
| `report-title` | Full thesis title (shown on cover and in footer) |
| `supervisor-name` | Supervisor last name, first name |
| `editors` | Tuple of author names |
| `matrikelnr` | Student ID |
| `semester`, `report-date` | Display strings on the cover |
| `base-font`, `base-size` | Body text font and size |
| `german` | `true` = use `kapitel/`; `false` = use `chapters/` |

Typography constants (`par-leading`, `section-spacing-top`, etc.) are also in `config.typ` and imported via `#import "config.typ": *` in `main.typ`. Do not touch these unless layout changes are explicitly requested.

---

## Chapter file structure

Every chapter file must begin with exactly these lines:

```typst
#import "../utils.typ": gap, eq, header, gl, gls, gll, glh, si, todo, silentheading

#let section = "Chapter Title"
#show: body => header(section, body)
```

Only import the functions you actually use in that file. The `header()` call sets the running page header and, when `inwriting = true`, appends a word count at the bottom of the chapter.

---

## Draft / writing mode (utils.typ)

Two flags at the top of `utils.typ` control draft behavior:

```typst
#let inwriting = true   // true → word counts + todo() annotations visible
#let draft = true       // must be true whenever inwriting is true (asserted)
```

Set both to `false` before generating the final submission PDF.

---

## Helper functions (utils.typ)

Import only what is needed per file. All functions are defined in `utils.typ`.

### `#gl("key")` — primary glossary function

- **First use in document:** outputs `Long Form (SHORT)` — e.g., `European Union (EU)`
- **Every subsequent use:** outputs the short form only — e.g., `EU`
- Never manually write the long form before calling `#gl()` — this causes double expansion.
- Never pass extra arguments: `#gl("key")` only, no `long:` parameter.
- If the key is missing from `data.typ`, the output is red error text.

```typst
// CORRECT
The #gl("eu")'s transition toward a climate-neutral economy...

// WRONG — causes "European Union (European Union (EU))"
The European Union (#gl("eu"))...
```

### `#glh("key")` — heading / caption short form

Always outputs the short form. **Does not register the key as "used."** Use inside `caption:` fields and section headings so that the List of Figures / TOC does not steal the first-use slot from the chapter body text.

```typst
// CORRECT — caption shows "HHI" without consuming the first-use slot
caption: [Results for #glh("hhi") under all scenarios.]

// WRONG — steals first-use slot; first #gl("hhi") in body text will then show short form only
caption: [Results for #gl("hhi") under all scenarios.]
```

**Rule: never use `#gl()` or `#gls()` inside `caption:` fields.** Always use `#glh()` for abbreviations in captions.

### `#gls("key")` — always short form

Outputs the short form and marks the key as used. Use inside equations and symbol definitions.

```typst
#eq($"IR" = frac(#gls("nd_imp"), #gls("nd_cons"))$)
```

### `#gll("key")` — lowercase long form

First use: `lowercase long form (SHORT)`. Subsequent uses: short form. Use when a term appears mid-sentence for the first time and the long form would otherwise be capitalized awkwardly.

```typst
...raising #gll("eolrr") rates for wind turbine scrap...
```

### `#eq(body, label: none, vars: ())` — block equation

Renders a numbered block equation. Optionally define variables below the equation:

```typst
#eq($"IR" = frac(M_"Nd", C_"Nd")$, label: <eq:3_ir>)

#eq(
  $"HHI" = sum_i s_i^2$,
  vars: (($s_i$, [market share of supplier country $i$]),)
)
```

### `#si(value, unit)` — SI unit helper

Keeps value and unit non-breaking. `unit` can be a built-in key string or any Typst math expression:

```typst
#si(8000, "kg")      // → 8000 kg
#si("", "perc")      // → % (unit only, for table column headers)
#si(12, $"kg"/"MW"$) // → 12 kg/MW (raw math expression)
```

Built-in unit keys: `rho`, `deg`, `perc`, `temp`, `stress`, `modulus`, `visc`, `ohm`, `jg`, `kg`, `mg`, `m3`, `N`, `au`, `none`.

### `#todo("text")` — draft annotation

Renders as red text with a pencil icon when `inwriting = true`; invisible in final output.

### `#silentheading(level, body)` — unnumbered heading

Creates a heading that appears in the outline/bookmarks but has no chapter number.

```typst
#silentheading(3, [Appendix Note])
```

### `#gap()` — vertical gap

Adds `0.5em` vertical space with a negative left-indent reset. Use between tight prose blocks.

---

## Glossary entries (data.typ)

All abbreviations and formula symbols must be registered in `data.typ` before they can be used with `#gl()`. Two separate lists exist: `glossary` (text abbreviations) and `symbols` (math symbols). Both are searched by all `gl*` functions.

**Glossary entry format:**

```typst
(
  key: "crma",
  short: "CRMA",
  long: "Critical Raw Materials Act",
  lower: "critical raw materials act",  // optional — required only if #gll() is used
),
```

**Symbol entry format:**

```typst
(
  key: "nd_imp",
  short: $M_"Nd"$,
  long: [Extra-EU imports of neodymium],
  lower: [extra-EU imports of neodymium],
  unit: [t]
),
```

**Workflow:** add the entry to `data.typ` first, then use `#gl()` in chapter text. Using a key that is not in `data.typ` produces red error text at compile time — not a silent failure.

---

## Labeling conventions

Every heading, figure, table, and equation must carry a label for cross-referencing. Labels go on the **same line** as the element.

**Format:** `<type:N_short-description>`

- `type` — one of `sec`, `fig`, `tab`, `eq`
- `N` — chapter number (1–6)
- `short-description` — lowercase, hyphen-separated slug

```typst
= Introduction <sec:1_introduction>
== Problem Statement <sec:1_problem-statement>

#figure(...) <fig:2_framework-overview>
#figure(..., kind: table) <tab:3_scenario-overview>
#eq($...$, label: <eq:3_ir-formula>)
```

**Rules:**
- Every `==` and `===` heading gets a label — even if not yet cross-referenced
- Subsection labels use the parent chapter's number: `<sec:3_bau-scenario>`, not `<sec:bau-scenario>`
- Labels must be unique across the entire document
- Cross-reference errors in single-chapter preview are expected — they resolve in the full `main.typ` compile

---

## Tables — bookmark style (default for all tables)

All tables use horizontal rules only (`stroke: none` on the table, explicit `table.hline()` for borders):

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
      table.hline(stroke: 0.2pt),  // optional thin separator between data rows
      [Row 2], [Value],
      table.hline(stroke: 1pt),
    )
  ],
  caption: [Caption text.],
  kind: table,
) <tab:N_short-description>
```

**Rules:**
- Always wrap `#table(...)` in `box(width: 80%)` inside `#figure()`
- `stroke: none` on the table
- `table.hline(stroke: 1pt)` before the header row and after the last data row
- `table.hline(stroke: 0.5pt)` after the header row
- `table.hline(stroke: 0.2pt)` between data rows is optional
- Always include `kind: table` so it appears in the List of Tables

---

## Introduce before display rule

Every figure, table, and equation **must be referenced by label and briefly introduced in the prose immediately before it appears**. No visual element may appear without a preceding sentence naming it.

```typst
// CORRECT
@tab:3_scenario-overview lists the four scenarios with their interventions.
#figure(...) <tab:3_scenario-overview>

// CORRECT (equation intro with colon)
IR measures physical import dependence:
#eq($"IR" = ...$, label: <eq:3_ir>)

// WRONG — figure appears without introduction
#figure(...) <tab:3_scenario-overview>
```

---

## Citations

### Style

APA Version 7, enforced by `#bibliography("items.bib", style: "apa")` in `main.typ`. Do not manually format reference lists.

### Inline page-number comments

Every `@citation` in chapter text must have an inline `/* */` block comment (or `//` line comment when no prose follows) on the same line showing the printed page number and a brief locating excerpt:

```typst
@Graedel2012 /* p.1064 — "three dimensions: supply risk, environmental implications, and vulnerability to supply restriction" */
@JRC_DeepDive25 /* p.10 — "sets benchmarks for 2030 for EU domestic extraction (10% …)" */
```

Use `/* */` block comments when prose continues on the same line. Use `//` only at end-of-line where nothing follows — everything after `//` on that line is invisible in the compiled PDF.

```typst
// WRONG — "What is missing..." will be invisible
...model @bio15. // p.10 — MSA definition. What is missing is a unified scenario model...

// CORRECT
...model @bio15. /* p.10 — MSA definition */
What is missing is a unified scenario model...
```

### Page number offset

Always use the **printed footer page number**, not the physical PDF page count. Sources with front matter (cover, colophon) have an offset. MDPI journal articles use "X of N" pagination — the printed page number is the journal page shown in the article header, not the PDF page count.

### Secondary citations

When the source you read (Paper A) attributes a claim to another paper (Paper B), mark this in the comment:

```typst
@paperA /* p.X — "claim text" [secondary — orig: Author Year] */
```

---

## Page-number offset reference

Check the offset for each source when first using it:

| Source type | How to determine offset |
|-------------|------------------------|
| JRC reports, government reports | Count front-matter pages; printed page = physical − offset |
| Journal articles (Elsevier, Wiley) | Physical PDF page 1 = journal page shown in article header |
| MDPI open-access articles | "X of N" in page footer = printed page; no offset |
| Book chapters | Check printed page number against PDF page count |

---

## Common mistakes to avoid

| Mistake | Correct approach |
|---------|-----------------|
| `Long Form (#gl("key"))` | `#gl("key")` alone — first use auto-expands |
| `#gl("key", long: "...")` | `#gl("key")` — function takes no extra arguments |
| `#gl("key")` inside a `caption:` field | Use `#glh("key")` in captions |
| Using a key not in `data.typ` | Add the entry to `data.typ` first |
| Prose after `//` on the same line as a citation | Move prose to next line, or use `/* */` block comment |
| Physical PDF page number in citation comments | Use the printed footer page number |
| Figure appears without a preceding introduction sentence | Add a prose sentence referencing `@label` before the figure |
| Table without `kind: table` | Always include `kind: table` for List of Tables numbering |

---

## Draft → submission checklist

- [ ] All `#todo()` annotations resolved
- [ ] `inwriting = false` and `draft = false` in `utils.typ`
- [ ] All figures introduced with a preceding prose sentence
- [ ] All `@citation` calls have `/* p.X — excerpt */` comments
- [ ] All abbreviations have entries in `data.typ`
- [ ] No `#gl()` calls inside `caption:` fields (use `#glh()`)
- [ ] Labels unique across the full document
- [ ] `items.bib` has an entry for every cited source
- [ ] `config.typ` title, author, date, and supervisor are correct

---

## Project-specific rules

*(Add thesis-specific instructions below this line when using this template for a new project.)*
