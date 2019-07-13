Time.class_eval do
  def s_display
    strftime('%d/%m/%Y')
  end

  def l_display
    strftime('%d/%m/%Y %H:%M:%S')
  end

  def to(end_date, humanize_display: true)
    diff_time = end_date - self
    dst_years = (diff_time / 1.year).floor
    dst_months = (diff_time / 1.month).floor - dst_years * 12
    diff_days = ((end_date - dst_years.years - dst_months.months) - self) / 1.day
    dst_weeks = (diff_days / 7).floor

    if humanize_display
      str = []
      str << "#{dst_years} years" if dst_years.positive?
      str << "#{dst_months} months" if dst_months.positive?
      str << "#{diff_days.floor} days" if diff_days.floor.positive?
      str << "(or #{dst_weeks} weeks)" if dst_weeks.positive?
      str.join(' ')
    else
      [dst_years, dst_months, dst_weeks, diff_days.floor]
    end
  end
end
