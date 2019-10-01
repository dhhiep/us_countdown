# frozen_string_literal: true

class String
  def to_date_picker
    Time.zone.strptime(self, '%d/%m/%Y').try(:to_datetime)
  end
end
