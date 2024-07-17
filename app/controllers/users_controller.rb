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

  private 

  def user_params 
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :location)
  end 
end 