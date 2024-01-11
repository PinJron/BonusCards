class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show = user

  def create
    candidate = User.find_by(email: user_params[:attributes][:email])

    if candidate
      @errors = true
    else
      @user = User.create!(user_params[:attributes])
    end
  end

  def update
    @errors = true unless user.update(user_params[:attributes])
  end

  private

  def user
    @user ||= User.find(params[:id])
  end

  def user_params
    params.require(:data).permit(attributes: :email)
  end
end
