require 'rails_helper'

RSpec.describe UserService, type: :service do
  let(:repository) { instance_double(UserRepository) }
  let(:service) { UserService.new }

  before do
    allow(UserRepository).to receive(:new).and_return(repository)
  end

  describe '#all_users' do
    it 'returns all users' do
      users = [ instance_double(User) ]
      allow(repository).to receive(:all).and_return(users)

      expect(service.all_users).to eq(users)
    end
  end

  describe '#find_user' do
    it 'finds a user by id' do
      user = instance_double(User)
      allow(repository).to receive(:find).with(1).and_return(user)

      expect(service.find_user(1)).to eq(user)
    end
  end
end
