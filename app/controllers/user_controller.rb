class UserController < ApplicationController
    include Crypto

    def new
    end

    def index
        @users = User.all
    end

    def create
        begin
            @user = User.new(user_params)
            @user.isValidate = false

            if @user.save!
                SignUpMailer.validate_email(@user.username, @user.email, request.host_with_port).deliver_later!
                redirect_to user_mail_path(:user_id => @user.id)
            else
                raise "Create User Failed!"
            end

        rescue ActiveRecord::RecordNotUnique
            render :json => {:error => true, :message => "Username is already in use"}
        rescue ActiveRecord::RecordInvalid
            render :json => {:error => true, :message => @@err_user_invalid}            
        end
    end

    def destroy
        @user = User.find(params[:id])
        @user.destroy
       
        redirect_to user_index_path
    end

    def mail
        @user = User.find(params[:user_id])
    end

    def validate
        begin   
            param = request.query_parameters
            username = decrypt(Base64.decode64(param['key']))

            @user = User.find_by(:username => username)
            @user.update(isValidate: true)
        rescue
            puts 'Hello'
        end
    end

    private
        @@err_user_invalid = "Record Invalid.<br>Username must be at least 8 characters.<br>Password must be at least 8 charcters."
        def user_params
            params.require(:user).permit(:username, :password, :email)
        end
end
