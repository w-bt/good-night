require 'rails_helper'

RSpec.describe ClockRepository, type: :repository do
  let(:repository) { ClockRepository.new }
  let!(:clock) { create(:clock) }

  describe '#find' do
    it 'finds a follow by id' do
      expect(repository.find(clock.id)).to eq(clock)
    end
  end
end
