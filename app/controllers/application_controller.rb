class ApplicationController < ActionController::Base
  # Rails 8 uses :exception by default, but you can also use :null_session for APIs
  # protect_from_forgery with: :exception  # This is now the default

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # Uncomment to enable modern browser requirements (Rails 8 feature)
  # allow_browser versions: :modern
end
