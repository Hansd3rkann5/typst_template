#import "utils.typ": si, used-keys,
#import "config.typ": glossary-text-size, symbol-text-size, glossary-inset, col-abbr, col-symbols, stroke-thick, stroke-thin, stroke-main
#import "data.typ": glossary, symbols

#context {
  let used-info      = used-keys.final()
  let used-keys-only = used-info.map(it => it.key)
  let filtered-abbr    = glossary.filter(a => str(a.key) in used-keys-only)
  let filtered-symbols = symbols.filter(s  => str(s.key)  in used-keys-only)

  if filtered-abbr.len() > 0 {
    set text(size: glossary-text-size)
    heading(numbering: none)[List of abbreviations]
    table(
      columns: col-abbr, stroke: none, inset: glossary-inset,
      align: (left + horizon, left + horizon),
      table.hline(stroke: stroke-thick),
      [*Abbreviation*], [*Definition*],
      table.hline(stroke: stroke-main),
      ..filtered-abbr.map(a => (
        a.short,
        a.long,
        table.hline(stroke: stroke-thin)
      )).flatten(),
      table.hline(stroke: stroke-thick),
    )
    if filtered-symbols.len() > 0 { pagebreak() }
  }

  if filtered-symbols.len() > 0 {
    set text(size: symbol-text-size)
    v(1cm)
    heading(numbering: none)[Formula Symbols]
    table(
      columns: col-symbols,
      stroke: none,
      inset: glossary-inset,
      align: (center + horizon, left + horizon, center + horizon, center + horizon),
      table.hline(stroke: stroke-thick),
      [*Symbol*], [*Description*], [*Unit*], [*Chapter*],
      table.hline(stroke: stroke-main),
      ..filtered-symbols.map(s => {
        let info = used-info.find(it => it.key == str(s.key))
        let ch = if info != none { info.ch } else { "-" }
        let rendered-unit = if s.unit == "" or s.unit == "none" { [-] } else { s.unit }
        (
          strong(s.short),
          s.long,
          text(style: "italic", rendered-unit),
          ch,
          table.hline(stroke: stroke-thin)
        )
      }).flatten(),
      table.hline(stroke: stroke-thick),
    )
  }
}
