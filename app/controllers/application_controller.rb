class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def user_signed_in?
    !!current_user
  end
  helper_method :user_signed_in?

  def current_user
    @current_user ||= User.where(id: session[:user_id]).first
  end
  helper_method :current_user

  def authenticate!
    redirect_to(root_path) and return unless user_signed_in?
  end

  def authenticate_admin!
    render status: :forbidden, text: "You don't have permission to perform that action." unless current_user.admin?
  end
end
