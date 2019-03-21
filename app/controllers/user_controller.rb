class UserController < ApplicationController
    def new
    end

    def index
        @users = User.all
    end

    def create
        begin
            @user = User.new(user_params)

            @user.save!
            redirect_to root_path
        rescue ActiveRecord::RecordNotUnique
            render :json => {:error => true, :message => "Username is already in use"}
        rescue ActiveRecord::RecordInvalid
            render :json => {:error => true, :message => @@err_user_invalid}            
        end
    end

    def destroy
        @user = User.find(params[:id])
        @user.destroy
       
        redirect_to admin_index_path
    end

    private
        @@err_user_invalid = "Record Invalid.<br>Username must be at least 8 characters.<br>Password must be at least 8 charcters."
        def user_params
            params.require(:user).permit(:username, :password)
        end
end
