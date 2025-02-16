require 'rails_helper'

RSpec.describe FollowService, type: :service do
  let(:repository) { instance_double(FollowRepository) }
  let(:service) { FollowService.new }
  let(:follower) { create(:user) }
  let(:followee) { create(:user) }
  let(:follow) { create(:follow, follower: follower, followee: followee) }

  before do
    allow(FollowRepository).to receive(:new).and_return(repository)
  end

  describe '#followers' do
    it 'returns followers of a user' do
      allow(repository).to receive(:followers).with(followee.id).and_return([ follower ])
      expect(service.followers(followee.id)).to eq([ follower ])
    end
  end
end
