class UsersController < ApplicationController
  before_action :set_user, only: [:show, :destroy]

  def show
  end

  def destroy
    if current_user == @user
      @user.destroy!
    end
    redirect_to root_path
  end

  private

  def set_user
    @user = User.find_by(nickname: params[:nickname])
  end
end
