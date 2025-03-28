# frozen_string_literal: true

module LatexYearlyPlanner
  module Xtypst
    class LittleCalendarRow
      DEFAULT_PARAMETERS = {
        inset: '1.5mm',
        week_with_numbers: true,
        link_to_week: true,
        week_number_placement: 'left',
        highlight_day: nil,
        highlight_week_numbers: false
      }.freeze

      attr_reader :week, :parameters

      def initialize(week, **parameters)
        @week = week
        @parameters = DEFAULT_PARAMETERS.merge(parameters.compact)
      end

      def to_typst
        row.join(', ')
      end

      private

      def row
        return row_internal unless parameters[:week_with_numbers]

        add_week!

        row_internal
      end

      def add_week!
        return row_internal.unshift(week_label) if parameters[:week_number_placement] == 'left'

        row_internal.push(week_label)
      end

      def week_label
        content = "block(inset: #{parameters[:inset]}, [#{week.number}])"
        content = "link(<#{week.id}>, #{content})" if parameters[:link_to_week]
        content = "table.cell(fill: luma(238), #{content})" if parameters[:highlight_week_numbers]
        content
      end

      def row_internal
        @row_internal ||= week.days.map(&method(:map_day))
      end

      def map_day(day)
        return '[]' unless day

        highlight = parameters[:highlight_day] == day

        content = "block(inset: #{parameters[:inset]}, #{'text(white)' if highlight}[#{day.day}])"
        content = "link(<#{day.id}>, #{content})"
        content = "table.cell(fill: black, #{content})" if highlight
        content
      end
    end
  end
end
