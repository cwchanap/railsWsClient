module Auth
    def auth()
        if cookies[:username] == nil
            redirect_to root_path()
        end
    end
end