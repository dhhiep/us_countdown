class Record < ApplicationRecord
  validates :name, presence: true
  validates :imm_type, presence: true
  validates :priority_date, presence: true

  def status
    generate_sample_dates = VisaBulletin.sample(priority_date)
    current_cut_off_dates = VisaBulletin.current_cut_off_dates
    VisaBulletin.distance_friendly(imm_type.to_sym, previous: current_cut_off_dates, current: generate_sample_dates)
  end
end
