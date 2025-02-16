require 'rails_helper'

RSpec.describe Followees::FolloweesClockWeekly, type: :model do
  let(:user) { create(:user) }
  let(:followee1) { create(:user) }
  let(:followee2) { create(:user) }
  let(:date) { Date.today }
  let(:follow_repository) { instance_double(FollowRepository) }
  let(:clock_weekly_repository) { instance_double(ClockWeeklyRepository) }
  let(:service) { Followees::FolloweesClockWeekly.new(user, date) }

  before do
    allow(FollowRepository).to receive(:new).and_return(follow_repository)
    allow(ClockWeeklyRepository).to receive(:new).and_return(clock_weekly_repository)
  end

  describe '#call' do
    context 'when followee clock weekly records exist' do
      let(:followee_ids_batch1) { [ followee1.id ] }
      let(:followee_ids_batch2) { [ followee2.id ] }
      let(:clock_weekly1) { create(:clock_weekly, user: followee1, week_start: date) }
      let(:clock_weekly2) { create(:clock_weekly, user: followee2, week_start: date) }

      before do
        allow(follow_repository).to receive(:find_followee_ids_in_batches).with(user.id, batch_size: Followees::FolloweesClockWeekly::BATCH_SIZE).and_yield(followee_ids_batch1).and_yield(followee_ids_batch2)
        allow(clock_weekly_repository).to receive(:find_by_users_and_date).with(followee_ids_batch1, date).and_return({ followee1.id => [ clock_weekly1 ] })
        allow(clock_weekly_repository).to receive(:find_by_users_and_date).with(followee_ids_batch2, date).and_return({ followee2.id => [ clock_weekly2 ] })
      end

      it 'fetches followee clock weekly records in batches' do
        result = service.call

        expect(result).to eq([
                               { user_id: followee1.id, clock_weekly: clock_weekly1 },
                               { user_id: followee2.id, clock_weekly: clock_weekly2 }
                             ])
      end
    end

    context 'when followee clock weekly records do not exist' do
      it 'returns an empty array if no followees are found' do
        allow(follow_repository).to receive(:find_followee_ids_in_batches).with(user.id, batch_size: Followees::FolloweesClockWeekly::BATCH_SIZE).and_yield([])
        allow(clock_weekly_repository).to receive(:find_by_users_and_date).with([], date).and_return({})

        result = service.call

        expect(result).to eq([])
      end
    end
  end
end
