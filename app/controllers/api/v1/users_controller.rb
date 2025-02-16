class Api::V1::UsersController < ApplicationController
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

  private

  def set_user
    @user = UserService.new.find_user(params[:id])
  end

  def user_params
    params.require(:user).permit(:name)
  end
end
