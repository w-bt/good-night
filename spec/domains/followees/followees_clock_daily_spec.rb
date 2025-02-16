require 'rails_helper'

RSpec.describe Followees::FolloweesClockDaily, type: :model do
  let(:user) { create(:user) }
  let(:followee1) { create(:user) }
  let(:followee2) { create(:user) }
  let(:date) { Date.today }
  let(:follow_repository) { instance_double(FollowRepository) }
  let(:clock_daily_repository) { instance_double(ClockDailyRepository) }
  let(:service) { Followees::FolloweesClockDaily.new(user, date) }

  before do
    allow(FollowRepository).to receive(:new).and_return(follow_repository)
    allow(ClockDailyRepository).to receive(:new).and_return(clock_daily_repository)
  end

  describe '#call' do
    context 'when followees are found' do
      let(:clock_daily1) { create(:clock_daily, user: followee1, date: date) }
      let(:clock_daily2) { create(:clock_daily, user: followee2, date: date) }

      before do
        followee_ids_batch1 = [ followee1.id ]
        followee_ids_batch2 = [ followee2.id ]
        allow(follow_repository).to receive(:find_followee_ids_in_batches).with(user.id, batch_size: Followees::FolloweesClockDaily::BATCH_SIZE).and_yield(followee_ids_batch1).and_yield(followee_ids_batch2)
        allow(clock_daily_repository).to receive(:find_by_users_and_date).with(followee_ids_batch1, date).and_return({ followee1.id => [ clock_daily1 ] })
        allow(clock_daily_repository).to receive(:find_by_users_and_date).with(followee_ids_batch2, date).and_return({ followee2.id => [ clock_daily2 ] })
      end

      it 'fetches followee clock daily records in batches' do
        result = service.call

        expect(result).to eq([
                               { user_id: followee1.id, clock_daily: clock_daily1 },
                               { user_id: followee2.id, clock_daily: clock_daily2 }
                             ])
      end
    end

    context 'when followees are not found' do
      before do
        allow(follow_repository).to receive(:find_followee_ids_in_batches).with(user.id, batch_size: Followees::FolloweesClockDaily::BATCH_SIZE).and_yield([])
        allow(clock_daily_repository).to receive(:find_by_users_and_date).with([], date).and_return({})
      end

      it 'returns an empty array if no followees are found' do
        result = service.call

        expect(result).to eq([])
      end
    end
  end
end
