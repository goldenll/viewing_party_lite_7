class UsersController < ApplicationController
  before_action :get_user, only: [:show]

  def new
    @user = User.new
  end
  
  def create
    user = user_params
    user[:email] = user[:email].downcase
    new_user = User.new(user)
    if new_user.save
      redirect_to user_path(new_user)
    else
      flash[:error] = "Invalid input"
      redirect_to new_user_path
    end
  end
  
  # def create
  #   @user = User.new(user_params)
  #   if @user.save
  #     redirect_to user_path(@user)
  #   elsif @user.name.empty? || @user.email.empty? || @user.password.empty? || @user.password_confirmation..empty?
  #     flash[:error] = "Missing required information"
  #     redirect_to new_user_path
  #   else
  #     flash[:error] = "Invalid input"
  #     redirect_to new_user_path
  #   end
  # end

  def show
    @facade = MovieFacade
  end

  def login_form 
  end
  
  def login_user
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.email}!"
        if user.admin? 
          redirect_to admin_dashboard_path
        elsif user.manager?
          redirect_to root_path
        else
          redirect_to user_path(user)
        end
    else 
      flash[:error] = "Invalid input"
      render :login_form
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def get_user
    @user = User.find(params[:id])
  end
end
