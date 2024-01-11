class UsersController < ApplicationController
  before_action :set_user, only: %i[show update]

  def index
    @users = User.all
    render json: @users
  end

  def show; end

  def create
    candidate = User.find_by(email: user_params[:attributes][:email])
    if candidate
      @errors = true
    else
      @user = User.create_or_find_by(user_params[:attributes])
    end
  end

  def update
    @errors = true unless @user.update(user_params[:attributes])
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:data).permit(attributes: :email)
  end
end
