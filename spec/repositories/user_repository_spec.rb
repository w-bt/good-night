require 'rails_helper'

RSpec.describe UserRepository, type: :repository do
  let(:repository) { UserRepository.new }
  let!(:user) { create(:user) }

  describe '#all' do
    it 'returns all users' do
      expect(repository.all).to include(user)
    end
  end

  describe '#find' do
    it 'finds a user by id' do
      expect(repository.find(user.id)).to eq(user)
    end
  end
end
