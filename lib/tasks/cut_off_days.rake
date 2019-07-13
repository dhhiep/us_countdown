namespace :cut_off_days do
  task fetch_visa_bulletin: :environment do
    CutOffDay.check_and_update!
  end
end
