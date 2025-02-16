require 'rails_helper'

RSpec.describe BackfillClockReportJob, type: :job do
  let(:user) { create(:user) }
  let(:clock) { create(:clock, user: user, clock_in: Time.current - 8.hours, clock_out: Time.current) }
  let(:service) { instance_double(ClockReportService) }

  before do
    allow(Clock).to receive(:find).with(clock.id).and_return(clock)
    allow(ClockReportService).to receive(:new).with(clock.id).and_return(service)
  end

  describe '#perform' do
    it 'calls ClockReportService to update the clock report' do
      expect(service).to receive(:update_clock_report)
      described_class.perform_now(clock.id)
    end
  end
end
