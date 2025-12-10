module Auth
  def auth
    return unless session[:curr_userid].nil?

    redirect_to root_path
  end
end
