# frozen_string_literal: true

class VisaBulletin < ApplicationRecord
  serialize :data, Hash
  include ActionView::Helpers::DateHelper
  include SendGrid

  default_scope { order(uuid: :desc) }

  TYPES = {
    f1: 1,
    f2a: 2,
    f2b: 3,
    f3: 4,
    f4: 5,
  }.freeze

  class << self
    def check_and_update(time = nil)
      time.is_a?(Time) ? new.fetch_and_update(time) : new.check_and_update_with_range
    end

    def improvement_speed(imm_type)
      distance_friendly(
        imm_type,
        previous: VisaBulletin.second.cut_off_dates,
        current: VisaBulletin.first.cut_off_dates,
      )
    end

    def distance_friendly(imm_type, previous: {}, current: {})
      imm_type = imm_type.to_sym
      date_range_valid?(imm_type, previous: previous, current: previous)

      previous_month = previous[imm_type]
      current_month = current[imm_type]

      previous_month == current_month ? 'No Increase!!!' : previous_month.to(current_month)
    rescue StandardError
      # TODO:Handle error
    end

    def date_range_valid?(imm_type, previous: {}, current: {})
      return if previous[imm_type].is_a?(Time) && current[imm_type].is_a?(Time)

      raise 'Invalid date range'
    end

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

  def check_and_update_with_range
    [1.month.ago, Time.current, 1.month.from_now].each do |time_node|
      resource = vb_obj(time_node)
      next if VisaBulletin.find_by_uuid(resource[:uuid]) # Doesn't fetch old data

      next unless fetch_and_update(time_node)

      send_email("The Visa Bulletin has new update for #{resource[:uuid]}")
    end
  end

  def fetch_and_update(time)
    data = fetch_data(vb_obj(time)[:url])
    return unless data

    add_visa_bulletin(vb_obj(time)[:uuid], data)
  end

  private

  def add_visa_bulletin(uuid, data)
    visa_bulletin = VisaBulletin.where(uuid: uuid).first_or_initialize
    visa_bulletin.update(data: data)
  end

  def send_email(subject)
    from = SendGrid::Email.new(email: 'US-COUNTDONW@hiepdinh.info')
    to = SendGrid::Email.new(email: 'hoanghiepitvnn@gmail.com')
    content = Content.new(type: 'text/html', value: 'Please go to https://us-countdown.herokuapp.com/ to view new content')
    mail = SendGrid::Mail.new(from, subject, to, content)
    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    sg.client.mail._('send').post(request_body: mail.to_json)
  end

  def fetch_vb_data(url)
    Nokogiri::HTML(open(url))
  rescue StandardError => _e
    puts 'Parse fail'
  end

  def fetch_data(url)
    html = fetch_vb_data(url)
    return unless html

    cut_off_table = html.css('table')[0]
    open_days_table = html.css('table')[6]

    {
      cut_off: extract_data(cut_off_table),
      open: extract_data(open_days_table),
    }
  end

  def extract_data(table_content)
    TYPES.inject({}) do |result, obj|
      value = table_content.css('tr')[obj[1]].css('td')[1].text
      result.merge obj[0] => (Time.strptime(value, '%d%b%y') rescue value)
    end
  end

  def vb_obj(time)
    {
      uuid: time.strftime('%Y%m'),
      url: vb_url(time),
    }
  end

  def vb_url(time)
    "https://travel.state.gov/content/travel/en/legal/visa-law0/visa-bulletin/#{vb_uri(time)}"
  end

  def vb_uri(time)
    year = time.strftime('%Y').to_i
    year += 1 if time.strftime('%m').to_i >= 10

    "#{year}/visa-bulletin-for-#{time.strftime('%B').downcase}-#{time.strftime('%Y')}.html"
  end
end
