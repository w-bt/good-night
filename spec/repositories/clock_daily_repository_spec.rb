require 'rails_helper'

RSpec.describe ClockDailyRepository, type: :repository do
  let(:user) { create(:user) }
  let(:clock) { create(:clock, user: user, clock_in: Time.now, clock_out: Time.now + 1.hour) } # 1 hour duration

  describe '#update_daily_report' do
    context 'when clock is present' do
      it 'creates a new ClockDaily record if not exists' do
        expect {
          ClockDailyRepository.new.update_report(clock)
        }.to change { ClockDaily.count }.by(1)

        daily_report = ClockDaily.find_by(user_id: user.id, date: clock.created_at.to_date)
        expect(daily_report.total_duration).to eq(clock.duration)
      end

      it 'updates existing ClockDaily record' do
        existing_report = create(:clock_daily, user: user, date: clock.created_at.to_date, total_duration: 1800) # 30 minutes

        expect {
          ClockDailyRepository.new.update_report(clock)
        }.to change { existing_report.reload.total_duration }.by(clock.duration)

        expect(existing_report.total_duration).to eq(5400) # 1 hour + 30 minutes
      end
    end

    context 'when clock is nil' do
      it 'does not update anything' do
        expect {
          ClockDailyRepository.new.update_report(nil)
        }.not_to change { ClockDaily.count }
      end
    end
  end

  describe '#find_by_users_and_date' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:date) { Date.today }
    let(:repository) { ClockDailyRepository.new }

    context 'when clock daily records exist' do
      let!(:clock_daily1) { create(:clock_daily, user: user1, date: date) }
      let!(:clock_daily2) { create(:clock_daily, user: user2, date: date) }

      it 'fetches clock daily records for multiple users' do
        result = repository.find_by_users_and_date([ user1.id, user2.id ], date)
        expect(result.keys).to match_array([ user1.id, user2.id ])
        expect(result[user1.id].first).to eq(clock_daily1)
        expect(result[user2.id].first).to eq(clock_daily2)
      end
    end

    context 'when clock daily records do not exist' do
      it 'returns an empty hash if no records are found' do
        result = repository.find_by_users_and_date([ user1.id, user2.id ], date)
        expect(result).to be_empty
      end
    end
  end
end
