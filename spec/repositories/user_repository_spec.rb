require 'rails_helper'

RSpec.describe UserRepository, type: :repository do
  let(:repository) { UserRepository.new }
  let!(:user) { create(:user) }

  describe '#all' do
    it 'returns all users' do
      expect(repository.all).to include(user)
    end
  end
end
