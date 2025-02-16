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
end
