# spec/repositories/clock_repository_spec.rb
require 'rails_helper'

RSpec.describe ClockUserRepository, type: :repository do
  let(:user) { create(:user) }
  let(:repository) { ClockUserRepository.new(user) }

  describe '#find_active_clock' do
    it 'finds the active clock record' do
      active_clock = create(:clock, user: user, clock_in: Time.current, clock_out: nil)
      clock = repository.find_active_clock
      expect(clock).to eq(active_clock)
    end

    it 'returns nil if no active clock record exists' do
      clock = repository.find_active_clock
      expect(clock).to be_nil
    end
  end

  describe '#create_clock' do
    it 'creates a new clock record' do
      clock = repository.create_clock(clock_in: Time.current, clock_out: nil)
      expect(clock).to be_persisted
      expect(clock.user).to eq(user)
      expect(clock.clock_in).not_to be_nil
      expect(clock.clock_out).to be_nil
    end
  end

  describe '#update_clock' do
    let(:clock) { create(:clock, user: user, clock_in: Time.current, clock_out: nil) }

    it 'updates the clock record with clock_out time' do
      updated_clock = repository.update_clock(clock, clock_out: Time.current + 8.hours)
      expect(updated_clock.clock_out).not_to be_nil
    end
  end

  describe '#all_clocks' do
    it 'returns all clock records for the user' do
      clock1 = create(:clock, user: user, clock_in: 2.hours.ago, clock_out: 1.hour.ago)
      clock2 = create(:clock, user: user, clock_in: 1.hour.ago, clock_out: Time.current)
      clocks = repository.all_clocks
      expect(clocks).to include(clock1, clock2)
    end

    it 'returns an empty array if no clock records exist for the user' do
      clocks = repository.all_clocks
      expect(clocks).to be_empty
    end
  end
end
