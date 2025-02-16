class ClockWeeklyRepository
  def update_report(clock)
    return unless clock.present?

    clock_weekly = ::ClockWeekly.find_or_initialize_by(user_id: clock.user_id, week_start: clock.created_at.beginning_of_week)
    clock_weekly.total_duration += clock.duration
    clock_weekly.save
  end

  def find_by_users_and_date(user_ids, date)
    ClockWeekly.where(user_id: user_ids, week_start: date).group_by(&:user_id)
  end
end
