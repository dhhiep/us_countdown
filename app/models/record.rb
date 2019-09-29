class Record < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :priority_date, presence: true

  validates :imm_type, presence: true
  validate  :imm_type_data

  before_save :before_save

  def esimtate_date(time)
    VisaBulletin.distance_friendly(imm_type.to_sym, previous: time, current: VisaBulletin.sample(priority_date))
  end

  def openning_date_estimation
    esimtate_date(VisaBulletin.current_openning_dates)
  end

  def cutoff_date_estimation
    esimtate_date(VisaBulletin.current_cut_off_dates)
  end

  private

  def before_save
    self.imm_type = imm_type.downcase
  end

  def imm_type_data
    return if VisaBulletin::TYPES.keys.include?(imm_type.downcase.to_sym)

    errors.add(:imm_type, "must be is #{VisaBulletin::TYPES.keys.join(', ').upcase}")
  end
end
