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
end
