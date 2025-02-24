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

  describe 'PUT #update' do
    before do
      allow(user_service).to receive(:find_user).with(user.id.to_s).and_return(user)
    end

    context 'with valid params' do
      before do
        allow(user_service).to receive(:update_user).and_return(true)
      end

      it 'updates the requested user' do
        put :update, params: { id: user.to_param, user: attributes }
        expect(response).to be_successful
      end
    end

    context 'with invalid params' do
      before do
        allow(user_service).to receive(:update_user).and_return(false)
      end

      it 'returns an unprocessable entity response' do
        put :update, params: { id: user.to_param, user: attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      allow(user_service).to receive(:find_user).with(user.id.to_s).and_return(user)
      allow(user_service).to receive(:delete_user).and_return(true)
    end

    it 'destroys the requested user' do
      delete :destroy, params: { id: user.to_param }
      expect(response).to have_http_status(:no_content)
    end
  end

  describe 'follow' do
    let(:follower) { create(:user) }
    let(:followee) { create(:user) }
    let(:follow_service) { instance_double(FollowService) }

    before do
      allow(FollowService).to receive(:new).and_return(follow_service)
      allow(follow_service).to receive(:followers).with(followee.id.to_s).and_return([ follower ])
      allow(follow_service).to receive(:followees).with(follower.id.to_s).and_return([ followee ])
      allow(follow_service).to receive(:create_follow).and_return(double("Follow"))
    end

    describe 'GET #followers' do
      it 'returns a success response' do
        get :followers, params: { id: followee.id }
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'GET #followees' do
      it 'returns a success response' do
        get :followees, params: { id: follower.id }
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'PUT #update_follow_status' do
      context 'when following a user successfully' do
        before do
          allow(follow_service).to receive(:find_follow_by_users).and_return(nil)
          allow(follow_service).to receive(:create_follow).and_return(double("Follow"))
        end

        it 'returns a created response' do
          put :update_follow_status, params: { id: followee.id, user_id: follower.id, action_type: "follow" }

          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)['message']).to eq("Successfully followed user")
        end
      end

      context 'when already following the user' do
        before do
          allow(follow_service).to receive(:find_follow_by_users).and_return(double("Follow"))
        end

        it 'returns a success response with a message' do
          put :update_follow_status, params: { id: followee.id, user_id: follower.id, action_type: "follow" }

          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)['message']).to eq("Already following user")
        end
      end

      context 'when unfollowing a user successfully' do
        before do
          allow(follow_service).to receive(:find_follow_by_users).and_return(double("Follow"))
          allow(follow_service).to receive(:delete_follow).and_return(true)
        end

        it 'returns a success response' do
          put :update_follow_status, params: { id: followee.id, user_id: follower.id, action_type: "unfollow" }

          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)['message']).to eq("Successfully unfollowed user")
        end
      end

      context 'when trying to unfollow a user that is not followed' do
        before do
          allow(follow_service).to receive(:find_follow_by_users).and_return(nil)
        end

        it 'returns a not found response' do
          put :update_follow_status, params: { id: followee.id, user_id: follower.id, action_type: "unfollow" }

          expect(response).to have_http_status(:not_found)
          expect(JSON.parse(response.body)['error']).to eq("Follow relationship not found")
        end
      end

      context 'when action_type is invalid' do
        it 'returns an unprocessable entity response' do
          put :update_follow_status, params: { id: followee.id, user_id: follower.id, action_type: "invalid_action" }

          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)['error']).to eq("Invalid action_type")
        end
      end
    end
  end

  describe 'clock' do
    let(:clock_service) { instance_double(ClockService) }

    before do
      allow(ClockService).to receive(:new).and_return(clock_service)
    end

    describe 'POST #update_clock' do
      context 'when clocking in successfully' do
        before do
          allow(clock_service).to receive(:clock_in).and_return({ success: 'Clocked in successfully', clock: build(:clock, user: user, clock_in: Time.current) })
        end

        it 'clocks in successfully' do
          post :update_clock, params: { id: user.id, action_type: 'clock_in' }

          expect(response).to have_http_status(:created)
          expect(JSON.parse(response.body)['success']).to eq('Clocked in successfully')
        end
      end

      context 'when already clocked in' do
        before do
          allow(clock_service).to receive(:clock_in).and_return({ error: 'Already clocked in' })
        end

        it 'returns an error' do
          post :update_clock, params: { id: user.id, action_type: 'clock_in' }

          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)['error']).to eq('Already clocked in')
        end
      end

      context 'when clocking out successfully' do
        before do
          allow(clock_service).to receive(:clock_out).and_return({ success: 'Clocked out successfully', clock: build(:clock, user: user, clock_in: Time.current, clock_out: Time.current + 8.hours) })
        end

        it 'clocks out successfully' do
          post :update_clock, params: { id: user.id, action_type: 'clock_out' }

          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)['success']).to eq('Clocked out successfully')
        end
      end

      context 'when there is no active clock in' do
        before do
          allow(clock_service).to receive(:clock_out).and_return({ error: 'No active clock in' })
        end

        it 'returns an error' do
          post :update_clock, params: { id: user.id, action_type: 'clock_out' }

          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)['error']).to eq('No active clock in')
        end
      end

      context 'when action_type is invalid' do
        it 'returns an unprocessable entity response' do
          post :update_clock, params: { id: user.id, action_type: 'invalid_action' }

          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)['error']).to eq('Invalid action_type')
        end
      end
    end

    describe 'GET #clocks' do
      let(:clocks) { create_list(:clock, 3, user: user) }

      before do
        allow(user_service).to receive(:find_user).with(user.id.to_s).and_return(user)
        allow(user).to receive(:clocks).and_return(clocks)

        allow(clock_service).to receive(:all_clocks).and_return(clocks)
      end

      it 'returns a list of clock records' do
        get :clocks, params: { id: user.id }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(3)
      end
    end

    describe 'GET #followees_clock_daily' do
      let(:date) { Date.today }
      let(:followees_clock_daily_service) { instance_double(FolloweesClockDailyService) }
      let(:followee) { create(:user) }

      before do
        allow(FolloweesClockDailyService).to receive(:new).with(user, date).and_return(followees_clock_daily_service)
      end

      context 'when followees are found' do
        let(:clock_daily) { create(:clock_daily, user: user, date: date) }

        before do
          allow(followees_clock_daily_service).to receive(:call).and_return([ { user_id: followee.id, clock_daily: clock_daily } ])
        end

        it 'returns clock daily records for followees' do
          get :followees_clock_daily, params: { id: user.id, date: date.to_s }

          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)).to eq([ { 'user_id' => followee.id, 'clock_daily' => clock_daily.as_json } ])
        end
      end

      context 'when followees are not found' do
        before do
          allow(followees_clock_daily_service).to receive(:call).and_return([])
        end

        it 'returns an empty array if no followees are found' do
          get :followees_clock_daily, params: { id: user.id, date: date.to_s }

          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)).to eq([])
        end
      end
    end

    describe 'GET #followees_clock_weekly' do
      let(:date) { Date.today }
      let(:followees_clock_weekly_service) { instance_double(FolloweesClockWeeklyService) }
      let(:followee) { create(:user) }

      before do
        allow(FolloweesClockWeeklyService).to receive(:new).with(user, date).and_return(followees_clock_weekly_service)
      end

      context 'when followees are found' do
        let(:clock_weekly) { create(:clock_weekly, user: user, week_start: date) }

        before do
          allow(followees_clock_weekly_service).to receive(:call).and_return([ { user_id: followee.id, clock_weekly: clock_weekly } ])
        end

        it 'returns clock weekly records for followees' do
          get :followees_clock_weekly, params: { id: user.id, week_start: date.to_s }

          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)).to eq([ { 'user_id' => followee.id, 'clock_weekly' => clock_weekly.as_json } ])
        end
      end

      context 'when followees are not found' do
        before do
          allow(followees_clock_weekly_service).to receive(:call).and_return([])
        end

        it 'returns an empty array if no followees are found' do
          get :followees_clock_weekly, params: { id: user.id, week_start: date.to_s }

          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)).to eq([])
        end
      end
    end
  end
end
