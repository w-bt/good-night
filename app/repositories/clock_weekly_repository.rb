class ClockWeeklyRepository
  def update_report(clock)
    return unless clock.present?

    clock_weekly = ::ClockWeekly.find_or_initialize_by(user_id: clock.user_id, week_start: clock.created_at.beginning_of_week)
    clock_weekly.total_duration += clock.duration
    clock_weekly.save
  end
end
