class LoginController < ApplicationController
  def index; end

  def new
    @user = User.find_by!(user_params)
  rescue ActiveRecord::RecordNotFound
    render json: { error: true, message: "invalid User" }
  else
    cookies[:username] = @user.username
    session[:curr_userid] = @user.id
    redirect_to articles_path
  end

  def destroy
    cookies.delete(:username)
    session[:curr_userid] = nil
    redirect_to root_path
  end

  private

  def user_params
    params.expect(user: %i[username password])
  end
end
