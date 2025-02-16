require 'rails_helper'

RSpec.describe Clocks::ClockReport, type: :model do
  let(:user) { create(:user) }
  let(:clock) { create(:clock, user: user, clock_in: Time.current - 8.hours, clock_out: Time.current, duration: 8.hours.to_i) }
  let(:service) { Clocks::ClockReport.new }

  describe '#calculate_daily' do
    let(:clock_report) { instance_double(ClockDailyRepository) }

    before do
      allow(ClockDailyRepository).to receive(:new).and_return(clock_report)
    end

    it 'calls Clocks::ClockReport to update the daily report' do
      expect(clock_report).to receive(:update_report)

      service.calculate_daily(clock: clock)
    end
  end

  describe '#calculate_weekly' do
    let(:clock_report) { instance_double(ClockWeeklyRepository) }

    before do
      allow(ClockWeeklyRepository).to receive(:new).and_return(clock_report)
    end

    it 'calls Clocks::ClockReport to update the weekly report' do
      expect(clock_report).to receive(:update_report)

      service.calculate_weekly(clock: clock)
    end
  end
end
