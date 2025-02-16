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
    before do
      allow(repository).to receive(:followers).with(followee.id).and_return([ follower ])
    end

    it 'returns followers of a user' do
      expect(service.followers(followee.id)).to eq([ follower ])
    end
  end

  describe '#followees' do
    before do
      allow(repository).to receive(:followees).with(follower.id).and_return([ followee ])
    end

    it 'returns followees of a user' do
      expect(service.followees(follower.id)).to eq([ followee ])
    end
  end
end
