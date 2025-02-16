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

  describe '#find_follow_by_users' do
    it 'returns the follow record for given follower and followee' do
      result = repository.find_follow_by_users(follower.id, followee.id)
      expect(result).to eq(follow)
    end
  end

  describe '#create' do
    let(:attributes) { { follower_id: follower.id, followee_id: followee.id } }

    before do
      # Ensure no duplicate follows exist before creating
      Follow.where(attributes).destroy_all
    end

    it 'creates a new follow' do
      new_follow = repository.create(attributes)
      expect(new_follow).to be_persisted
      expect(new_follow.follower_id).to eq(follower.id)
      expect(new_follow.followee_id).to eq(followee.id)
    end
  end

  describe '#delete' do
    it 'deletes a follow' do
      expect { repository.delete(follow) }.to change { Follow.count }.by(-1)
    end
  end
end
