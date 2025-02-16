require 'rails_helper'

RSpec.describe FolloweesClockWeeklyService, type: :service do
  let(:user) { create(:user) }
  let(:date) { Date.today }
  let(:followees_clock_weekly) { instance_double(Followees::FolloweesClockWeekly) }
  let(:service) { FolloweesClockWeeklyService.new(user, date) }

  before do
    allow(Followees::FolloweesClockWeekly).to receive(:new).with(user, date).and_return(followees_clock_weekly)
  end

  describe '#call' do
    it 'calls FolloweesClockWeekly' do
      expect(followees_clock_weekly).to receive(:call)
      service.call
    end
  end
end
