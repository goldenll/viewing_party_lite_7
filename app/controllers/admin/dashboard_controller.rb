class Admin::DashboardController < ApplicationController
  def index
    if current_admin?
      @users = User.all
    else
      flash[:error] = "You must be logged in to do that"
      redirect_to root_path 
    end
  end
end
