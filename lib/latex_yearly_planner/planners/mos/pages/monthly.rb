# frozen_string_literal: true

module LatexYearlyPlanner
  module Planners
    module Mos
      module Pages
        class Monthly < Face
          attr_reader :month

          def set(month)
            @month = month

            self
          end

          def title
            "text(#{params.get(:heading_size)})[#{i18n.t("calendar.month.#{month.name.downcase}")}<#{month.id}>]"
          end

          def content
            <<~TYPST
              grid(
                columns: 1,
                rows: #{params.get(:habit_tracker) ? "(1fr, #{params.get(:habit_tracker_height) || "40%"})" : "2"},
                gutter: #{params.get(:gap_width)},
                #{Xtypst::LargeCalendar.new(month, **params.object(:large_calendar)).to_typst},
                #{lower_half}
              )
            TYPST
          end

          def top_menu_month
            month
          end

          def highlight_side_menu_months
            [month]
          end

          private

          def lower_half
            if params.get(:habit_tracker)
              days = month.moment.end_of_month.day
              rows = params.get(:habit_tracker_rows) || 18
              cell_size = params.get(:habit_tracker_cell_size) || '0.67 * line_height'
              <<~TYPST
                text(#{params.get(:habit_tracker_font_size) || '0.8em'}, table(
                  columns: (1fr, #{([cell_size] * days).join(', ')}),
                  rows: (#{([cell_size] * (rows + 1)).join(', ')}),
                  inset: (x: 0pt, y: 2pt), align: (center + bottom),
                  stroke: (x, y) => if y == 0 { none } else if x == 0 { (bottom: (thickness: thin_stroke, dash: "dotted")) } else { thin_stroke },
                  [], ..range(1, #{days + 1}).map(i => [#i])
                ))
              TYPST
            else
              "rect_pattern(#{params.get(:pattern)})"
            end
          end
        end
      end
    end
  end
end
