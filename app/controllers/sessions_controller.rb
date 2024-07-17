class SessionsController < ApplicationController 
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user.authenticate(params[:password])
      cookies.encrypted[:location] = { value: params[:location], expires: 1.day}
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.name}!"
      redirect_to user_path(user)
    else
      flash[:error] = "Sorry, your credentials are bad."
      render :login_form
    end
  end

  def destroy
    session.delete :user_id
    redirect_to root_path
    flash[:success] = "Logged out successfully"
  end

end