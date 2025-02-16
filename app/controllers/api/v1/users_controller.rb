class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: [ :show, :update, :destroy, :update_clock, :clocks, :followees_clock_daily, :followees_clock_weekly ]

  def index
    @users = UserService.new.all_users
    render json: @users, status: :ok
  end

  def show
    render json: @user, status: :ok
  end

  def create
    @user = UserService.new.create_user(user_params)
    if @user.persisted?
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if UserService.new.update_user(@user, user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    UserService.new.delete_user(@user)
    head :no_content
  end

  def followers
    @followers = FollowService.new.followers(params[:id])
    render json: @followers, status: :ok
  end

  def followees
    @followees = FollowService.new.followees(params[:id])
    render json: @followees, status: :ok
  end

  def update_follow_status
    follower = User.find(params[:id])  # Follower is the one taking action
    followee = User.find(params[:user_id])  # Followee is the target user

    case params[:action_type]
    when "follow"
      handle_follow_action(follower, followee)
    when "unfollow"
      handle_unfollow_action(follower, followee)
    else
      render json: { error: "Invalid action_type" }, status: :unprocessable_entity
    end
  end

  def update_clock
    case params[:action_type]
    when "clock_in"
      clock_in
    when "clock_out"
      clock_out
    else
      render json: { error: "Invalid action_type" }, status: :unprocessable_entity
    end
  end

  def clocks
    service = ClockService.new(@user)
    result = service.all_clocks
    render json: result, status: :ok
  end

  def followees_clock_daily
    date = params[:date] ? Date.parse(params[:date]) : Time.current.to_date
    followees_clock_daily = FolloweesClockDailyService.new(@user, date).call
    render json: followees_clock_daily, status: :ok
  end

  def followees_clock_weekly
    date = params[:week_start] ? Date.parse(params[:week_start]) : Time.current.to_date.beginning_of_week
    followees_clock_weekly = FolloweesClockWeeklyService.new(@user, date).call
    render json: followees_clock_weekly, status: :ok
  end

  private

  def set_user
    @user = UserService.new.find_user(params[:id])
  end

  def user_params
    params.require(:user).permit(:name)
  end

  def handle_follow_action(follower, followee)
    follow = FollowService.new.find_follow_by_users(follower.id, followee.id)
    if follow
      render json: { message: "Already following user" }, status: :ok
    else
      follow = FollowService.new.create_follow(follower_id: follower.id, followee_id: followee.id)
      if follow
        render json: { message: "Successfully followed user" }, status: :ok
      else
        render json: { error: "Unable to follow user" }, status: :unprocessable_entity
      end
    end
  end

  def handle_unfollow_action(follower, followee)
    follow = FollowService.new.find_follow_by_users(follower.id, followee.id)
    if follow
      FollowService.new.delete_follow(follow)
      render json: { message: "Successfully unfollowed user" }, status: :ok
    else
      render json: { error: "Follow relationship not found" }, status: :not_found
    end
  end

  def clock_in
    service = ClockService.new(@user)
    result = service.clock_in

    if result[:error]
      render json: { error: result[:error] }, status: :unprocessable_entity
    else
      render json: result, status: :created
    end
  end

  def clock_out
    service = ClockService.new(@user)
    result = service.clock_out

    if result[:error]
      render json: { error: result[:error] }, status: :unprocessable_entity
    else
      render json: result, status: :ok
    end
  end
end
