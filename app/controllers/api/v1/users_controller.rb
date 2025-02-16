class Api::V1::UsersController < ApplicationController
  def index
    @users = UserService.new.all_users
    render json: @users, status: :ok
  end

  def show
    render json: @user, status: :ok
  end

  private

  def set_user
    @user = UserService.new.find_user(params[:id])
  end
end
