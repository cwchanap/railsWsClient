module ApplicationHelper
  def auth
    return unless cookies.signed[:username].nil?

    redirect_to root_path
  end
end
