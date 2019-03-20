module UserHelper
    def getUserName(user_id)
        User.find_by_id(user_id).username
    end
end
