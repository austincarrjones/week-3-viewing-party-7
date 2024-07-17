class ApplicationController < ActionController::Base
  helper_method :current_user, :require_user

  def current_user
    @_current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def require_user
    if !current_user
      flash[:error] = "You must log in"
      redirect_to root_path
    end
  end
end
