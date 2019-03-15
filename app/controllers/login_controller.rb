class LoginController < ApplicationController
    def new
        begin
            user = User.find_by!(user_params)
        rescue ActiveRecord::RecordNotFound
            redirect_to root_path(flash: {message: "invalid user"})
        else
            redirect_to articles_path()
        end
    end

    def index
    end

    private
        def user_params
            params.require(:user).permit(:username, :password)
        end
end
