class Record < ApplicationRecord
  validates :name, presence: true
  validates :imm_type, presence: true
  validates :priority_date, presence: true

  def status
    CutOffDay.calculate_distance(imm_type, priority_date)
  end
end
