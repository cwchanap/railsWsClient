class LoginController < ApplicationController
    def new
        begin
            @user = User.find_by!(user_params)
        rescue ActiveRecord::RecordNotFound
            render :json => {:error => true, :message => "invalid User"}
        else
            cookies[:username] = @user.username
            redirect_to articles_path()
        end
    end

    def index
    end

    def destroy
        cookies.delete(:username)
        redirect_to root_path()
    end

    private
        def user_params
            params.require(:user).permit(:username, :password)
        end
end
