# frozen_string_literal: true

class VisaBulletin < ApplicationRecord
  serialize :data, Hash

  default_scope { order(uuid: :desc) }

  TYPES = {
    f1: 1,
    f2a: 2,
    f2b: 3,
    f3: 4,
    f4: 5,
  }.freeze

  class << self
    def sample(time = Time.current)
      TYPES.inject({}) do |hash, data|
        hash.merge data[0] => time
      end
    end

    def current_openning_dates
      all.first.openning_dates
    end

    def current_cut_off_dates
      all.first.cut_off_dates
    end
  end

  def openning_dates
    data&.dig(:open) || {}
  end

  def cut_off_dates
    data&.dig(:cut_off) || {}
  end

  def dates_by_type(data_type)
    data_type.to_sym == :openning_dates ? openning_dates : cut_off_dates
  end

  def time_id
    Time.strptime(uuid, '%Y%m')
  end

  def sample_by_time_id
    self.class.sample(time_id)
  end
end
