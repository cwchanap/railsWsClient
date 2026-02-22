module ApplicationHelper
  def auth
    return clear_session_and_redirect if missing_session?
    return if User.exists?(id: session[:curr_userid])

    clear_session_and_redirect
  end

  private

  def missing_session?
    cookies.signed[:username].nil? || session[:curr_userid].nil?
  end

  def clear_session_and_redirect
    cookies.delete(:username)
    session.delete(:curr_userid)
    redirect_to root_path
  end
end
