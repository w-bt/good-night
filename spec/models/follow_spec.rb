require 'rails_helper'

RSpec.describe Follow, type: :model do
  let(:follower) { create(:user) }
  let(:followee) { create(:user) }
  let!(:existing_follow) { create(:follow, follower: follower, followee: followee) }

  it { should belong_to(:follower).class_name('User') }
  it { should belong_to(:followee).class_name('User') }

  it { should validate_presence_of(:follower_id) }
  it { should validate_presence_of(:followee_id) }
  it { should validate_uniqueness_of(:follower_id).scoped_to(:followee_id).case_insensitive }
end
