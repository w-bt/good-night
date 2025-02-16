require 'rails_helper'

RSpec.describe Follows::Follow, type: :model do
  let(:attributes) { { follower_id: 1, followee_id: 2 } }
  let(:follow) { Follows::Follow.new(attributes) }

  describe '#initialize' do
    it 'initializes with given attributes' do
      expect(follow.follower_id).to eq(1)
      expect(follow.followee_id).to eq(2)
    end
  end

  describe '#valid?' do
    it 'returns true when both follower_id and followee_id are present' do
      expect(follow.valid?).to be true
    end

    it 'returns false when follower_id is missing' do
      follow.follower_id = nil
      expect(follow.valid?).to be false
    end

    it 'returns false when followee_id is missing' do
      follow.followee_id = nil
      expect(follow.valid?).to be false
    end
  end
end
