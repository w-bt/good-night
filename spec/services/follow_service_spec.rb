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

  describe '#find_follow_by_users' do
    before do
      allow(repository).to receive(:find_follow_by_users).with(follower.id, followee.id).and_return(follow)
    end

    it 'returns the follow record for given follower and followee' do
      expect(service.find_follow_by_users(follower.id, followee.id)).to eq(follow)
    end
  end

  describe '#create_follow' do
    let(:attributes) { { follower_id: follower.id, followee_id: followee.id } }

    before do
      allow(repository).to receive(:create).with(attributes).and_return(follow)
    end

    it 'creates a new follow' do
      expect(service.create_follow(attributes)).to eq(follow)
    end

    it 'returns false if follow is invalid' do
      attributes = { follower_id: nil, followee_id: followee.id }
      expect(service.create_follow(attributes)).to be false
    end
  end

  describe '#delete_follow' do
    before do
      allow(repository).to receive(:delete).with(follow).and_return(follow)
    end

    it 'deletes a follow' do
      expect(service.delete_follow(follow)).to eq(follow)
    end
  end
end
