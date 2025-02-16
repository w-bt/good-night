module Clocks
  class ClockReport
    def calculate_daily(clock:)
      ClockDailyRepository.new.update_report(clock)
    end

    def calculate_weekly(clock:)
      ClockWeeklyRepository.new.update_report(clock)
    end
  end
end
