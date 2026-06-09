// config.typ — change these values to configure the thesis

// --- Cover Texts ---
#let university = "University of Bayreuth"
#let program-name = [M.Sc.: Your Program Name]
#let report-title = "Your Thesis Title Goes Here"
#let report-subject = "Your Subject / Course"
#let semester = "Summersemester 26"
#let report-date = "01.01.2026"

// --- Authors and Supervision ---
#let supervisor-name = "Lastname, Firstname"
#let editors = (
  "Firstname Lastname",
)
#let matrikelnr = "0000000"

// --- Page Header ---
#let header-left-text = "Your Project / Module Name"  // left side of the running header

// --- Cover Dimensions & Spacing ---
#let cover-size-large = 22pt
#let cover-size-medium = 18pt
#let cover-size-small = 14pt
#let logo-width = 60%

// --- Typography ---
#let base-font = "Noto Sans Indic Siyaq Numbers"
#let base-size = 12pt
#let math-font = "New Computer Modern Math"
#let footer-size = 10pt

// --- Strokes & Line Weights ---
#let stroke-main = 0.5pt
#let stroke-thick = 1pt
#let stroke-thin = 0.2pt

// --- Paragraph & List Layout ---
#let par-leading = 0.8em       // line spacing
#let par-indent = 0em
#let par-spacing = 1.5em
#let list-indent = 1em
#let list-body-indent = 0.5em
#let list-spacing-above = 1.5em
#let outline-indent = 2em

// --- Heading Spacing ---
#let section-spacing-top = 3em
#let section-spacing-bottom = 2em
#let h2-above = 2.8em
#let h2-below = 1.8em
#let h3-above = 1.5em
#let h3-below = 1em

// --- List of Figures / List of Tables Entry Spacing ---
#let lof-entry-spacing = 0.55em  // vertical gap between entries
#let lof-combined = false         // true  → LoF and LoT share one page
                                  // false → each list on its own page

// --- General Figure Spacing ---
#let figure-spacing-above = 2em
#let figure-spacing-below = 1.5em

// --- Table & Glossary Settings ---
#let table-spacing-above = 2em
#let table-inset = 6.5pt
#let caption-text-size = 10pt
#let glossary-inset = 0.6em
#let glossary-text-size = 12pt
#let symbol-text-size = 12pt

// --- Column Widths ---
#let col-abbr = (4cm, 1fr)
#let col-symbols = (2.5cm, 1fr, 1.5cm, 2.5cm)

// --- Colors & Dynamic Texts ---
#let footer-text = report-title
#let main-color-link = blue
