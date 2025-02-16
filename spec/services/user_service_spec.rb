require 'rails_helper'

RSpec.describe UserService, type: :service do
  let(:repository) { instance_double(UserRepository) }
  let(:service) { UserService.new }
  let(:user) { instance_double(User) }

  before do
    allow(UserRepository).to receive(:new).and_return(repository)
  end

  describe '#all_users' do
    let(:users) { [ instance_double(User) ] }

    before do
      allow(repository).to receive(:all).and_return(users)
    end

    it 'returns all users' do
      expect(service.all_users).to eq(users)
    end
  end

  describe '#find_user' do
    before do
      allow(repository).to receive(:find).with(1).and_return(user)
    end

    it 'finds a user by id' do
      expect(service.find_user(1)).to eq(user)
    end
  end

  describe '#create_user' do
    let(:attributes) { { name: Faker::Name.name } }

    before do
      allow(repository).to receive(:create).with(attributes).and_return(user)
    end

    it 'creates a new user' do
      expect(service.create_user(attributes)).to eq(user)
    end
  end

  describe '#update_user' do
    let(:attributes) { { name: Faker::Name.name } }

    before do
      allow(repository).to receive(:update).with(user, attributes).and_return(true)
    end

    it 'updates an existing user' do
      expect(service.update_user(user, attributes)).to be_truthy
    end
  end

  describe '#delete_user' do
    before do
      allow(repository).to receive(:delete).with(user).and_return(true)
    end

    it 'deletes a user' do
      expect(service.delete_user(user)).to be_truthy
    end
  end
end
