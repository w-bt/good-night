class ClockReportService
  def initialize(clock_id)
    @clock_id = clock_id
    @repository = ClockRepository.new
    @domain = Clocks::ClockReport.new
  end

  def update_clock_report
    clock = @repository.find(@clock_id)
    return unless clock.present?
    return unless clock.clock_out.present?

    ActiveRecord::Base.transaction do
      @domain.calculate_daily(clock: clock)
    end
  end
end
