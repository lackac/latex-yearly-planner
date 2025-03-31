#let stroke_width = 1pt
#let thin_stroke = 0.5pt
#let line_height = 5.5mm
#let nudge = 0.35pt

#set page(
  width: 148.6mm,
  height: 198.1mm,

  margin: (
    top: line_height - thin_stroke - nudge,
    bottom: line_height - thin_stroke - nudge,
    right: 1.5 * line_height - thin_stroke - nudge,
    left: 1.5 * line_height - thin_stroke - nudge,
  )
)

#set text(
  size: 10pt,
)

#let dotted = pattern(
  size: (line_height, line_height),
  place(
    dx: thin_stroke,
    dy: thin_stroke,
    circle(
      radius: thin_stroke,
      fill: luma(25%)
    )
  ),
)

#let lined = pattern(
  size: (line_height, line_height),
  place(
    line(
      start: (0%, 6%),
      end: (100%, 6%),
      stroke: thin_stroke
    ),
  )
)

#let rect_pattern(pattern) = rect(
  width: 100%,
  height: 100%,
  fill: pattern
)


#let vert_stack_bottom_outset(..content, last_content) = {
  stack(
    dir: ttb,
    spacing: 1fr,
    ..content, stack(dir: ttb, spacing: line_height, last_content, [])
  )
}

#let jot(pattern, height, name) = {
  stack(
    dir: ttb,
    spacing: line_height,
    box(
      height: line_height, width: 100%, stroke: (bottom: stroke_width),
      align(horizon, name)
    ),
    box(
      height: height,
      width: 100%, rect_pattern(pattern)
    )
  )
}

#let black_table_cell(text) = table.cell(fill: black, text)


#block(
  width: 100%,
  height: 100%,
  place(rect_pattern(dotted))
)

