class ClockDailyRepository
  def update_report(clock)
    return unless clock.present?

    clock_daily = ::ClockDaily.find_or_initialize_by(user_id: clock.user_id, date: clock.created_at.to_date)
    clock_daily.total_duration += clock.duration
    clock_daily.save
  end
end
