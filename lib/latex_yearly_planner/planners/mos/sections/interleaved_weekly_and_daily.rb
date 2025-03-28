# frozen_string_literal: true

module LatexYearlyPlanner
  module Planners
    module Mos
      module Sections
        class InterleavedWeeklyAndDaily < Section
          def pages
            params.weeks.flat_map do |week|
              [week].concat(week.days.flat_map { |d| [d, [d, :notes]] })
            end
          end
        end
      end
    end
  end
end
