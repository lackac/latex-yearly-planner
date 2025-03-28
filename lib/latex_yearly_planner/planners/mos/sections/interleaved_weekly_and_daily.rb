# frozen_string_literal: true

module LatexYearlyPlanner
  module Planners
    module Mos
      module Sections
        class InterleavedWeeklyAndDaily < Section
          def pages
            params.weeks.flat_map do |week|
              [week].concat(week.days)
            end
          end
        end
      end
    end
  end
end
