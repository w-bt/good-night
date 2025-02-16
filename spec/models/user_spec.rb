require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:name) }

  it { should have_many(:follower_relationships).with_foreign_key('followee_id').class_name('Follow').dependent(:destroy) }
  it { should have_many(:followers).through(:follower_relationships).source(:follower) }

  it { should have_many(:followee_relationships).with_foreign_key('follower_id').class_name('Follow').dependent(:destroy) }
  it { should have_many(:followees).through(:followee_relationships).source(:followee) }

  it { should have_many(:clocks).dependent(:destroy) }
  it { should have_many(:clock_dailies).dependent(:destroy) }
  it { should have_many(:clock_weeklies).dependent(:destroy) }

  describe 'follower and followee relationships' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }

    it 'allows a user to follow another user' do
      user1.followees << user2
      expect(user1.followees).to include(user2)
      expect(user2.followers).to include(user1)
    end

    it 'allows a user to have followers' do
      user2.followers << user1
      expect(user2.followers).to include(user1)
      expect(user1.followees).to include(user2)
    end
  end
end
