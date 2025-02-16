# spec/repositories/clock_repository_spec.rb
require 'rails_helper'

RSpec.describe ClockRepository, type: :repository do
  let(:user) { create(:user) }
  let(:repository) { ClockRepository.new(user) }

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
end
