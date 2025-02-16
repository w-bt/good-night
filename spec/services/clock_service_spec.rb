require 'rails_helper'

RSpec.describe ClockService, type: :service do
  let(:user) { create(:user) }
  let(:service) { ClockService.new(user) }
  let(:repository) { instance_double(ClockRepository) }

  before do
    allow(ClockRepository).to receive(:new).with(user).and_return(repository)
  end

  describe '#clock_in' do
    context 'when not already clocked in' do
      before do
        allow(repository).to receive(:find_active_clock).and_return(nil)
        allow(repository).to receive(:create_clock).and_return(build(:clock, user: user, clock_in: Time.current))
      end

      it 'clocks in successfully' do
        result = service.clock_in

        expect(result[:success]).to eq('Clocked in successfully')
        expect(result[:clock]).to be_a(Clock)
      end
    end

    context 'when already clocked in' do
      before do
        allow(repository).to receive(:find_active_clock).and_return(build(:clock, user: user, clock_in: Time.current, clock_out: nil))
      end

      it 'returns an error' do
        result = service.clock_in

        expect(result[:error]).to eq('Already clocked in')
      end
    end
  end

  describe '#clock_out' do
    context 'when there is an active clock in' do
      let(:active_clock) { build(:clock, user: user, clock_in: Time.current, clock_out: nil) }

      before do
        allow(repository).to receive(:find_active_clock).and_return(active_clock)
        allow(repository).to receive(:update_clock).and_return(active_clock)
      end

      it 'clocks out successfully' do
        result = service.clock_out

        expect(result[:success]).to eq('Clocked out successfully')
        expect(result[:clock]).to be_a(Clock)
      end
    end

    context 'when there is no active clock in' do
      before do
        allow(repository).to receive(:find_active_clock).and_return(nil)
      end

      it 'returns an error' do
        result = service.clock_out

        expect(result[:error]).to eq('No active clock in')
      end
    end
  end

  describe '#all_clocks' do
    context 'when clock records exist for the user' do
      let(:clock1) { create(:clock, user: user, clock_in: 2.hours.ago, clock_out: 1.hour.ago) }
      let(:clock2) { create(:clock, user: user, clock_in: 1.hour.ago, clock_out: Time.current) }

      it 'returns all clock records for the user' do
        allow(repository).to receive(:all_clocks).and_return([ clock1, clock2 ])

        clocks = service.all_clocks
        expect(clocks).to include(clock1, clock2)
      end
    end

    context 'when no clock records exist for the user' do
      before do
        allow(repository).to receive(:all_clocks).and_return([])
      end

      it 'returns an empty array if no clock records exist for the user' do
        clocks = service.all_clocks
        expect(clocks).to be_empty
      end
    end
  end
end
