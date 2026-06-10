#import "data.typ": glossary, symbols
#import "config.typ": header-left-text
#import "@preview/wordometer:0.1.4": total-words

#let inwriting = true   // true  → #todo() annotations visible, word counts shown
#let draft    = true    // must be true when inwriting is true

#assert(not(inwriting and not(draft)), message: "If inwriting is true, draft should be true as well.")

// --- HELPERS ---

// Red draft annotation — invisible when inwriting = false
#let todo(it) = [
  #if inwriting [
    #text(size: 0.8em)[#emoji.pencil] #text(it, fill: red, weight: 600)
  ]
]

// Unnumbered heading that still appears in outline and bookmarks
#let silentheading(level, body) = [
  #heading(outlined: false, level: level, numbering: none, bookmarked: true)[#body]
]

// Small vertical gap with left-indent reset
#let gap() = {
  v(0.5em)
  h(-1.8em)
}

// --- EQUATIONS ---

// Block equation with optional label and variable definition list
// vars: array of (symbol, description) pairs — listed below the equation
#let eq(body, label: none, vars: ()) = {
  block(width: 100%)[
    #math.equation(block: true, body)
    #if label != none { label }
  ]
  if vars.len() > 0 {
    pad(left: 1.1em, top: -0.5em)[
      #set text(size: 0.85em)
      #grid(
        columns: (2em, 1.5em, auto),
        row-gutter: 0.4em,
        ..vars.map(v => (v.at(0), [=], v.at(1))).flatten()
      )
    ]
  }
}

// --- GLOSSARY LOGIC ---

#let used-keys = state("used-keys", ())

// Internal: register a key with its first-use heading location
#let register-key(k) = context {
  let history = used-keys.get()
  if not history.any(it => it.key == k) {
    let ch-num = counter(heading).get()
    let ch-str = ch-num.map(str).join(".")
    used-keys.update(h => h + ((key: k, ch: ch-str),))
  }
}

// #gl("key") — "Long Form (SHORT)" on first use, "SHORT" thereafter
#let gl(key) = context {
  let k = str(key)
  let entry = (glossary + symbols).find(e => str(e.key) == k)

  if entry == none {
    return text(red)["#k" is not defined in data.typ]
  }

  let history = used-keys.get()
  let is-first = not history.any(it => it.key == k)

  if is-first {
    register-key(k)
    [#entry.at("long", default: entry.short) (#entry.short)]
  } else {
    entry.short
  }
}

// #glh("key") — always SHORT, no registration (safe for headings; prevents TOC pre-trigger)
#let glh(key) = context {
  let k = str(key)
  let entry = (glossary + symbols).find(e => str(e.key) == k)
  if entry == none {
    return text(red)["#k" is not defined in data.typ]
  }
  entry.short
}

// #gls("key") — always SHORT, marks key as used (for use inside equations)
#let gls(key) = context {
  let k = str(key)
  let entry = (glossary + symbols).find(e => str(e.key) == k)

  if entry == none {
    return text(red)[short "#k" is not defined in data.typ]
  }

  register-key(k)
  entry.short
}

// #gll("key") — "lowercase long form (SHORT)" on first use, "SHORT" thereafter
#let gll(key) = context {
  let k = str(key)
  let entry = (glossary + symbols).find(e => str(e.key) == k)

  if entry == none {
    return text(red)[lower for "#k" is not defined in data.typ]
  }

  let history = used-keys.get()
  let is-first = not history.any(it => it.key == k)

  if is-first {
    register-key(k)
    [#entry.at("lower", default: entry.short) (#entry.short)]
  } else {
    entry.short
  }
}

// --- PAGE HEADER ---

// Call once per chapter file via: #show: body => header("Chapter Title", body)
#let header(section_title, body) = {
  set page(
    header: context {
      let all_headings = query(selector(heading.where(level: 1)))
      let target = all_headings.filter(h => h.location().page() <= here().page()).at(-1, default: none)

      let display_title = if target != none {
        if target.numbering != none {
          let num = counter(heading).at(target.location()).at(0)
          [#num #target.body]
        } else {
          target.body
        }
      } else {
        section_title
      }

      grid(
        columns: (1fr, 1fr),
        align: (left + bottom, right + bottom),
        inset: (bottom: 5pt),
        stroke: (bottom: 0.5pt),
        text(weight: "regular", section_title),
        image("figures/Logo.png", height: 16pt)
      )
    }
  )

  body
  if inwriting {
    v(1em)
    align(right)[
      #text(fill: luma(160), size: 0.78em, style: "italic")[#section_title: #total-words words]
    ]
  }
}

// --- SI UNIT HELPER ---

// #si(value, unit) — non-breaking value + unit pair
// unit: string key from dict below, or any Typst math expression
#let si(value, unit) = {
  let units = (
    rho: $g / (c m^3)$,
    deg: $degree$,
    perc: [$%$],
    temp: $degree C$,
    stress: [$M P a$],
    modulus: [$G P a$],
    visc: $P a dot s$,
    ohm: $Omega$,
    jg: $J / g$,
    kg: [$k g$],
    mg: [$m g$],
    m3: $m^3$,
    N: [$N$],
    au: [a.u.],
    "none": [$-$]
  )

  let final-unit = if type(unit) == str and unit in units {
    units.at(unit)
  } else {
    unit
  }

  box([
    #if str(value).len() > 0 [$#value$#h(0.07em, weak: true)]
    #final-unit
  ])
}
