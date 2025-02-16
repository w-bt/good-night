require 'rails_helper'

RSpec.describe ClockReportService, type: :service do
  let(:user) { create(:user) }
  let(:clock) { create(:clock, user: user, clock_in: Time.current - 8.hours, clock_out: Time.current, duration: 8.hours.to_i) }
  let(:domain) { instance_double(Clocks::ClockReport) }
  let(:service) { ClockReportService.new(clock.id) }

  before do
    allow(Clocks::ClockReport).to receive(:new).and_return(domain)
  end

  describe '#update_clock_report' do
    it 'calls ClockDailyRepository to update the clock report' do
      expect(domain).to receive(:calculate_daily).with(clock: clock)
      expect(domain).to receive(:calculate_weekly).with(clock: clock)
      service.update_clock_report
    end
  end
end
