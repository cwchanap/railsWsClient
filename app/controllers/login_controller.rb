class LoginController < ApplicationController
  def index; end

  def create
    up = user_params
    @user = User.find_by(username: up[:username])

    if @user&.authenticate(up[:password])
      cookies.signed[:username] = @user.username
      session[:curr_userid] = @user.id
      redirect_to articles_path
    else
      render json: { error: true, message: "invalid User" }, status: :unauthorized
    end
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
