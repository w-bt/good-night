class ClockDailyRepository
  def update_report(clock)
    return unless clock.present?

    clock_daily = ::ClockDaily.find_or_initialize_by(user_id: clock.user_id, date: clock.created_at.to_date)
    clock_daily.total_duration += clock.duration
    clock_daily.save
  end

  def find_by_users_and_date(user_ids, date)
    ClockDaily.where(user_id: user_ids, date: date).group_by(&:user_id)
  end
end
