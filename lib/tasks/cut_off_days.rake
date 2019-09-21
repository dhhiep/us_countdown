namespace :cut_off_days do
  task auto_fetch: :environment do
    VisaBulletin.check_and_update
  end

  task fetch_visa_bulletin: :environment do
    time = Time.strptime(ENV['DATE'], '%Y%m')
    VisaBulletin.check_and_update(time)
  rescue StandardError
    raise 'DATE argument invalid!'
  end

  task fetch_all: :environment do
    time = Time.strptime(ENV['DATE'], '%Y%m')
    while time < Time.current
      VisaBulletin.check_and_update(time)
      time += 1.month
    end
  end
end
