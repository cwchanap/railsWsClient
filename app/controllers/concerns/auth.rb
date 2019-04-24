module Auth
    def auth
        if session[:curr_userid] == nil
            redirect_to root_path()
        end
    end
end