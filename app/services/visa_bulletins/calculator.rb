# frozen_string_literal: true

module VisaBulletins
  class Calculator < Base
    class << self
      def improvement_speed(imm_type)
        distance_friendly(
          imm_type,
          previous: VisaBulletin.second.cut_off_dates,
          current: VisaBulletin.first.cut_off_dates,
        )
      end

      def distance_friendly(imm_type, previous: {}, current: {}, include_week: true)
        imm_type = imm_type.downcase.to_sym
        date_range_valid?(imm_type, previous: previous, current: previous)

        current_month = current[imm_type]
        previous_month = previous[imm_type]

        options = {}
        options[:include_week] = include_week

        previous_month == current_month ? 'No Increase!!!' : previous_month.to(current_month, options: options)
      rescue StandardError => _e
        # TODO: Handle error
      end

      private

      def date_range_valid?(imm_type, previous: {}, current: {})
        return if previous[imm_type].is_a?(Time) && current[imm_type].is_a?(Time)

        raise 'Invalid date range'
      end
    end
  end
end
