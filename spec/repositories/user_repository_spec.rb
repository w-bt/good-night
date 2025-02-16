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

  describe '#create' do
    it 'creates a new user' do
      attributes = { name: 'Jane Doe' }
      new_user = repository.create(attributes)
      expect(new_user).to have_attributes(attributes)
    end
  end

  describe '#update' do
    it 'updates an existing user' do
      attributes = { name: 'John Smith' }
      repository.update(user, attributes)
      user.reload
      expect(user.name).to eq('John Smith')
    end
  end
end
