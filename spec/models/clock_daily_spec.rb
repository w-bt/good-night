require 'rails_helper'

RSpec.describe ClockDaily, type: :model do
  let(:user) { create(:user) }
  let(:clock_daily) { build(:clock_daily, user: user) }

  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:date) }
    it { should validate_presence_of(:total_duration) }
    it { should validate_numericality_of(:total_duration).only_integer.is_greater_than_or_equal_to(0) }
  end
end
