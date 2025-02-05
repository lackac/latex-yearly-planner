# frozen_string_literal: true

module LatexYearlyPlanner
  module Planners
    module Mos
      module Pages
        class Daily < Face
          include DailyCallable

          attr_reader :day

          def set(day)
            @day = day

            self
          end

          def title
            <<~TYPST
              [#grid(
                columns: 2,
                rows: (1fr, 1fr),
                inset: 0mm,
                align: left,
                grid.cell(
                  rowspan: 2,
                  stroke: (right: thin_stroke),
                  pad(right: 2mm, text(#{params.get(:heading_size)})[#{day.day}])
                ),
                pad(
                  left: 2mm,
                  bottom: 1mm,
                  [*#{i18n.t("calendar.weekdays.full.#{day.name.downcase}")}*]
                ),
                pad(left: 2mm, top: 1mm, link(<#{day.month.id}>, [#{i18n.t("calendar.month.#{day.month.name.downcase}")}])),
              )<#{day.id}>]
            TYPST
          end

          def content
            <<~TYPST
              box(
                width: 100%, height: 100%,
                #{"place(rect_pattern(#{params.get(:pattern)})) +" if background_grid?}
                grid(
                  columns: (#{params.get(:left_column_width)}, 1fr),
                  gutter: #{params.get(:gap_width)},
                  #{left_column},
                  #{right_column}
                )
              )
            TYPST
          end

          def extra_menu_items
            return [] unless params.section_enabled?(:weekly)

            ["link(<#{day.week.id}>, [#{i18n.t('calendar.weekdays.full.week')} #{day.week.number}])"]
          end

          def highlight_side_menu_months
            [day.month]
          end

          def highlight_side_menu_quarters
            [day.quarter]
          end

          def top_menu_month
            day.month
          end

          private

          def left_column
            "stack(dir: ttb, spacing: 0.25 * line_height, #{run_methods_of(:left_column_items)})"
          end

          def right_column
            "stack(dir: ttb, spacing: 0.25 * line_height, #{run_methods_of(:right_column_items)})"
          end

          def run_methods_of(column)
            items = params.get(:"#{day.name.downcase}_#{column}") || params.get(column)
            items.map { |meth| send("my_#{meth}") }.join(",\n")
          end

          def background_grid?
            params.get(:"#{day.name.downcase}_background_grid") || params.get(:background_grid)
          end
        end
      end
    end
  end
end
