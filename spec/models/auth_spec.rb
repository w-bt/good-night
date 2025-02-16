require 'rails_helper'

RSpec.describe Auth, type: :model do
  let(:user) { create(:user) } # Ensure a user exists
  let(:auth) { create(:auth, user: user) }

  # ✅ Association Test
  it { should belong_to(:user) }

  # ✅ Validation Tests
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }

  describe 'password validations' do
    it 'is valid with a valid password' do
      auth = Auth.new(user: user, email: 'john.doe@example.com', password: 'password', password_confirmation: 'password')
      expect(auth).to be_valid
    end

    it 'is not valid without a password' do
      auth = Auth.new(user: user, email: 'john.doe@example.com', password: nil)
      expect(auth).to_not be_valid
    end

    it 'is not valid with a mismatched password confirmation' do
      auth = Auth.new(user: user, email: 'john.doe@example.com', password: 'password', password_confirmation: 'wrong_password')
      expect(auth).to_not be_valid
    end
  end

  describe 'authentication' do
    let(:auth) { create(:auth, user: user, email: 'john.doe@example.com', password: 'password') }

    it 'returns the auth when the password is correct' do
      expect(auth.valid_password?('password')).to be_truthy
    end

    it 'returns false when the password is incorrect' do
      expect(auth.valid_password?('wrong_password')).to be_falsey
    end
  end

  describe 'uniqueness validation' do
    it 'does not allow duplicate emails for the same user' do
      create(:auth, user: user, email: 'test@example.com')
      duplicate_auth = build(:auth, user: user, email: 'test@example.com')
      expect(duplicate_auth).not_to be_valid
    end
  end
end
