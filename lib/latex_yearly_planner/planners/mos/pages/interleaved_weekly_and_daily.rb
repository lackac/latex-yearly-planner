# frozen_string_literal: true

module LatexYearlyPlanner
  module Planners
    module Mos
      module Pages
        class InterleavedWeeklyAndDaily < Face
          def set(week_or_day)
            @real_page =
              case week_or_day
              when Calendar::Week then Weekly.new(section_config:, i18n:)
              when Calendar::Day  then Daily.new(section_config:, i18n:)
              else raise DevelopmentError, "don't know how to interleave a #{week_or_day.class.name} page"
              end
            @real_page.set(week_or_day)
            self
          end

          delegate :title, :content, :extra_menu_items, :highlight_side_menu_months, :highlight_side_menu_quarters,
                   :top_menu_month, to: :@real_page
        end
      end
    end
  end
end
