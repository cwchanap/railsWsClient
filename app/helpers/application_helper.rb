module ApplicationHelper
  def auth
    return unless cookies[:username].nil?

    redirect_to root_path
  end
end
