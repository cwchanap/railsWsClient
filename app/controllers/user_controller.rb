class UserController < ApplicationController
    def new
    end

    def create
        begin
            @user = User.new(user_params)

            @user.save
            redirect_to root_path
        rescue ActiveRecord::RecordNotUnique
            render :json => {:error => true, :message => "Username is already in use"}
        end
    end

    private
        def user_params
            params.require(:user).permit(:username, :password)
        end
end
