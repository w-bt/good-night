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
end
