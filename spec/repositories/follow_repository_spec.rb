require 'rails_helper'

RSpec.describe FollowRepository, type: :repository do
  let(:repository) { FollowRepository.new }
  let(:follower) { create(:user) }
  let(:followee) { create(:user) }
  let!(:follow) { create(:follow, follower: follower, followee: followee) }

  describe '#followers' do
    it 'returns followers of a user' do
      expect(repository.followers(followee.id)).to include(follower)
    end
  end

  describe '#followees' do
    it 'returns followees of a user' do
      expect(repository.followees(follower.id)).to include(followee)
    end
  end
end
