require 'rails_helper'

RSpec.describe ClockWeeklyRepository, type: :repository do
  let(:user) { create(:user) }
  let(:clock) { create(:clock, user: user, clock_in: Time.current - 8.hours, clock_out: Time.current, duration: 8.hours.to_i) }
  let(:clock_weekly_repo) { ClockWeeklyRepository.new }

  describe '#update_report' do
    context 'when ClockWeekly record exists' do
      let!(:clock_weekly) { create(:clock_weekly, user: user, week_start: clock.created_at.beginning_of_week, total_duration: 4.hours.to_i) }

      it 'updates the total_duration of the existing ClockWeekly record' do
        clock_weekly_repo.update_report(clock)
        clock_weekly.reload
        expect(clock_weekly.total_duration).to eq(12.hours.to_i)
      end
    end

    context 'when ClockWeekly record does not exist' do
      it 'creates a new ClockWeekly record with the correct total_duration' do
        expect {
          clock_weekly_repo.update_report(clock)
        }.to change { ClockWeekly.count }.by(1)

        clock_weekly = ClockWeekly.last
        expect(clock_weekly.user_id).to eq(user.id)
        expect(clock_weekly.week_start).to eq(clock.created_at.beginning_of_week)
        expect(clock_weekly.total_duration).to eq(8.hours.to_i)
      end
    end
  end
end
