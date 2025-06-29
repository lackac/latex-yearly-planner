# frozen_string_literal: true

module LatexYearlyPlanner
  module Planners
    module Mos
      module Pages
        class Weekly < Face
          attr_reader :week

          def set(week)
            @week = week

            self
          end

          def title
            label = "text(#{params.get(:heading_size)})[#{i18n.t('calendar.weekdays.full.week')} #{week.number}]"
            cells = [prev_link, label, next_link].compact

            <<~TYPST
              table(
                columns: #{cells.size},
                inset: 0mm,
                stroke: 0mm,
                #{cells.join(',')}
              ),
              #{labels}
            TYPST
          end

          def content
            <<~TYPST
              grid(
                columns: (1fr, 1fr#{', 1fr' if params.get(:compact_weekdays)}),
                rows: (#{weekly_rows}),
                #{weekly_grid}
              )
            TYPST
          end

          def top_menu_month
            highlight_side_menu_months.first
          end

          def highlight_side_menu_months
            @highlight_side_menu_months ||= week.months.select { |month| params.months.include? month }
          end

          def highlight_side_menu_quarters
            highlight_side_menu_months.map(&:quarter).uniq
          end

          private

          def labels
            "hide[~#{week.ids.map { |id| "<#{id}>" }.join(' ~')}]"
          end

          def index
            @index ||= params.weeks.index(week)
          end

          def prev_link
            return unless index > 0

            prev_week = params.weeks[index - 1]
            block_link(prev_week.id, '⬅︎')
          end

          def next_link
            return unless index < params.weeks.size - 1

            next_week = params.weeks[index + 1]
            block_link(next_week.id, '➡︎')
          end

          def block_link(target, label, inset: '1.5mm')
            "link(<#{target}>, block(inset: #{inset}, [#{label}]))"
          end

          def weekly_rows
            first_name_height = params.get(:first_row_height)
            name_height = params.get(:rest_row_height)
            rows = params.get(:generic_jotting_space) ? "#{params.get(:generic_jotting_space_height)}, " : ''
            rows += "#{first_name_height}, 1fr, #{name_height}, 1fr"
            rows += ", #{name_height}, 1fr, #{name_height}, 1fr" unless params.get(:compact_weekdays)
            rows
          end

          def weekly_grid
            (params.get(:generic_jotting_space) ? "#{jotting_space},\n" : '') +
              day_rows.join(",\n#{jotting_space},\n") + ",\n#{jotting_space}\n"
          end

          def day_rows
            compact_weekdays = params.get(:compact_weekdays)
            days = week.days.map(&method(:format_day))
            if compact_weekdays
              last_day = days.pop
              days[-1] += " + h(1fr) + #{last_day}"
            else
              days.push('[]')
            end
            days.map(&method(:align_day)).each_slice(compact_weekdays ? 3 : 2).map { |slice| slice.join(', ') }
          end

          def jotting_space
            @jotting_space ||= "grid.cell(colspan: #{params.get(:compact_weekdays) ? 3 : 2}, rect_pattern(#{params.get(:pattern)}))"
          end

          def format_day(day)
            first_day = params.months.first.first_day
            last_day = params.months.last.last_day

            return day_label(day) if day < first_day || day > last_day

            "link(<#{day.id}>, #{day_label(day)})"
          end

          def day_label(day)
            dayname = day.strftime('%A')
            daynum = day.strftime('%-d')

            "[#{i18n.t("calendar.weekdays.full.#{dayname.downcase}")}, #{daynum}]"
          end

          def align_day(day)
            "align(horizon, #{day})"
          end
        end
      end
    end
  end
end
