module ArticlesHelper
    def isUserMatch(article_user_id)
        curr_user = session[:curr_userid]
        article_user_id == curr_user
    end

    def changeTZ(time)
        time.in_time_zone(8).strftime("%Y-%m-%d %H:%M:%S")
    end
end
