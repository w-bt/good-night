require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:user_service) { instance_double(UserService) }
  let(:attributes) { { name: 'John Doe' } }

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

  describe 'POST #create' do
    context 'with valid params' do
      before do
        allow(user_service).to receive(:create_user).and_return(user)
      end

      it 'creates a new User' do
        post :create, params: { user: attributes }
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid params' do
      before do
        allow(user_service).to receive(:create_user).and_return(User.new)
      end

      it 'returns an unprocessable entity response' do
        post :create, params: { user: attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
