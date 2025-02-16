require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:user_service) { instance_double(UserService) }

  before do
    allow(UserService).to receive(:new).and_return(user_service)
    allow(user_service).to receive(:find_user).with(user.id.to_s).and_return(user)
  end

  describe 'GET #index' do
    before do
      allow(user_service).to receive(:all_users).and_return([ user ])
    end

    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    before do
      allow(user_service).to receive(:find_user).with(user.id.to_s).and_return(user)
    end

    it 'returns a success response' do
      get :show, params: { id: user.to_param }
      expect(response).to be_successful
    end
  end
end
