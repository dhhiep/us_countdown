require 'open-uri'

class CutOffDay < ApplicationRecord
  serialize :data, Hash
  include ActionView::Helpers::DateHelper

  TYPES = {
    f1: 1,
    f2a: 2,
    f2b: 3,
    f3: 4,
    f4: 5
  }.freeze

  class << CutOffDay
    TYPES.each do |key, value|
      define_method(key) do
        current[key]
      end

      define_method("previous_#{key}") do
        previous[key]
      end
    end
  end

  def self.current
    current_data&.data
  end

  def self.previous
    previous_data&.data
  end

  def self.current_data
    all.order(uuid: :desc).first
  end

  def self.previous_data
    all.order(uuid: :desc).second
  end

  def self.improvement_speed(imm_type)
    previous[imm_type.to_sym].to current[imm_type.to_sym] rescue ''
  end

  def self.check_and_update!
    new.check_and_update!
  end

  def self.calculate_distance(imm_type, date, month_cut_off: current)
    imm_type = imm_type.to_sym
    month_cut_off[imm_type].to(date)
  end

  def check_and_update!
    %i[previous current next].each do |key|
      resource = build_urls[key]
      next if CutOffDay.find_by_uuid(resource[:uuid]) # Doesn't fetch old data

      data = cut_off_days(resource[:url])
      next unless data

      cut_of_day = CutOffDay.where(uuid: resource[:uuid]).first_or_initialize
      cut_of_day.update(data: data)
    end
  end

  private

  def cut_off_days(url)
    html = Nokogiri::HTML(open(url)) rescue nil
    return unless html

    cut_off_table = html.css('table')[0]
    TYPES.inject({}) do |result, obj|
      value = cut_off_table.css('tr')[obj[1]].css('td')[1].text
      result.merge obj[0] => (Time.strptime(value, '%d%b%y') rescue value)
    end
  end

  def vb_base_url
    'https://travel.state.gov/content/travel/en/legal/visa-law0/visa-bulletin'
  end

  def build_urls(m_step: 1)
    {
      previous: {
        uuid: m_step.month.ago.strftime('%Y%m'),
        url: "#{vb_base_url}/#{vb_uri(m_step.month.ago)}"
      },
      current: {
        uuid: Time.current.strftime('%Y%m'),
        url: "#{vb_base_url}/#{vb_uri(Time.current)}"
      },
      next: {
        uuid: m_step.month.from_now.strftime('%Y%m'),
        url: "#{vb_base_url}/#{vb_uri(m_step.month.from_now)}"
      }
    }
  end

  def vb_uri(time)
    "#{time.strftime('%Y')}/visa-bulletin-for-#{time.strftime('%B').downcase}-#{time.strftime('%Y')}.html"
  end
end
