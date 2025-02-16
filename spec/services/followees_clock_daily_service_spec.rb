require 'rails_helper'

RSpec.describe FolloweesClockDailyService, type: :service do
  let(:user) { create(:user) }
  let(:date) { Date.today }
  let(:followees_clock_daily) { instance_double(Followees::FolloweesClockDaily) }
  let(:service) { FolloweesClockDailyService.new(user, date) }

  before do
    allow(Followees::FolloweesClockDaily).to receive(:new).with(user, date).and_return(followees_clock_daily)
  end

  describe '#call' do
    it 'calls FolloweesClockDaily' do
      expect(followees_clock_daily).to receive(:call)
      service.call
    end
  end
end
