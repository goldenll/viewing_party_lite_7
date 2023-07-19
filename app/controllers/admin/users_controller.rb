class Admin::UsersController < ApplicationController
  def show
    if current_admin?
      @user = User.find(params[:id])
    else
      flash[:error] = "You must be logged in to do that"
      redirect_to root_path 
    end
  end
end
