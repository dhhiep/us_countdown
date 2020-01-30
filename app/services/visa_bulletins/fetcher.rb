# frozen_string_literal: true

module VisaBulletins
  class Fetcher < Base
    class << self
      def check_and_update(time = nil)
        time.is_a?(Time) ? fetch_for_time(time) : fetch_for_latest_month
      end

      private

      def fetch_for_latest_month
        [1.month.ago, Time.current, 1.month.from_now].each do |time_node|
          resource = vb_obj(time_node)
          next if VisaBulletin.find_by_uuid(resource[:uuid]) # Doesn't fetch old data

          next unless fetch_for_time(time_node)

          puts "The Visa Bulletin has new update for #{resource[:uuid]}"
          # send_email("The Visa Bulletin has new update for #{resource[:uuid]}")
        end
      end

      def fetch_for_time(time)
        data = fetch_data(vb_obj(time)[:url])
        return unless data

        add_visa_bulletin(vb_obj(time)[:uuid], data)
      end

      def add_visa_bulletin(uuid, data)
        visa_bulletin = VisaBulletin.where(uuid: uuid).first_or_initialize
        visa_bulletin.update(data: data)
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
        VisaBulletin::TYPES.inject({}) do |result, obj|
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
  end
end
