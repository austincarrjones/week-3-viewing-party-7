class UsersController < ApplicationController 
  before_action :require_user, only: :show
  
  def new 
    @user = User.new()
  end 

  def show 
    @user = User.find(params[:id])
  end

  def create
    user = user_params
    user[:email] = user[:email].downcase
    new_user = User.create(user)
    session[:user_id] = new_user.id
    if new_user.save
      redirect_to user_path(new_user)
    else
      flash[:error] = new_user.errors.full_messages.to_sentence
      redirect_to register_path
    end
  end

  def login_form
  end

  def login
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

  def logout
    # binding.pry
    session.delete :user_id
    # cookies.encrypted.delete :location
    redirect_to root_path
    flash[:success] = "Logged out successfully"
  end

  def require_user
    if !current_user
      flash[:error] = "You must log in"
      redirect_to root_path
    end
  end

  private 

  def user_params 
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :location)
  end 
end 