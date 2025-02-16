class BackfillClockReportJob < ApplicationJob
  queue_as :default

  def perform(clock_id)
    ClockReportService.new(clock_id).update_clock_report
  end
end
