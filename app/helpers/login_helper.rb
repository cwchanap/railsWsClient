module LoginHelper
  def isAdmin
    user = User.find_by(id: session[:curr_userid])
    !user.nil? && user.username == "admin"
  end
end
