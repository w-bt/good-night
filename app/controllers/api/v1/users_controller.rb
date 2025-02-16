class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: [ :show, :update, :destroy ]

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

  private

  def set_user
    @user = UserService.new.find_user(params[:id])
  end

  def user_params
    params.require(:user).permit(:name)
  end
end
