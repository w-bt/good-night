require 'rails_helper'

RSpec.describe Clock, type: :model do
  let(:user) { create(:user) }
  let(:clock) { build(:clock, user: user) }

  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:user_id) }

    context 'when clock_in and clock_out are both nil' do
      it 'is invalid if another record with null clock_in and clock_out exists for the user' do
        create(:clock, user: user, clock_in: nil, clock_out: nil)
        clock.clock_in = nil
        clock.clock_out = nil
        expect(clock).not_to be_valid
        expect(clock.errors[:base]).to include('Each user can not have more than one record with null clock_in and null clock_out')
      end
    end

    context 'when clock_in is nil' do
      it 'is invalid if another record with null clock_in exists for the user' do
        create(:clock, user: user, clock_in: nil)
        clock.clock_in = nil
        expect(clock).not_to be_valid
        expect(clock.errors[:clock_in]).to include('Each user can not have more than one record with null clock_in')
      end
    end

    context 'when clock_out is nil' do
      it 'is invalid if another record with null clock_out exists for the user' do
        create(:clock, user: user, clock_out: nil)
        clock.clock_out = nil
        expect(clock).not_to be_valid
        expect(clock.errors[:clock_out]).to include('Each user can not have more than one record with null clock_out')
      end
    end
  end

  describe 'callbacks' do
    it 'calculates duration when clock_out is set' do
      clock = create(:clock, user: user, clock_in: 2.hours.ago, clock_out: nil)
      clock.update(clock_out: Time.current)

      expect(clock.duration).to eq((clock.clock_out - clock.clock_in).to_i)
    end
  end
end
