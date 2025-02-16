class Api::V1::UsersController < ApplicationController
  def index
    @users = UserService.new.all_users
    render json: @users, status: :ok
  end
end
