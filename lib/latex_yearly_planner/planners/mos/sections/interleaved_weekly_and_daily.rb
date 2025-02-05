# frozen_string_literal: true

module LatexYearlyPlanner
  module Planners
    module Mos
      module Sections
        class InterleavedWeeklyAndDaily < Section
          def pages
            first_day = params.months.first.first_day
            last_day = params.months.last.last_day
            params.weeks.flat_map do |week|
              [week].concat(week.days.filter { |d| d >= first_day && d <= last_day })
            end
          end
        end
      end
    end
  end
end
