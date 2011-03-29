class UsersController < ApplicationController
  def new
    @title = "Sign in"
  end

  def show
    @user = User.find(params[:id])
  end

end
