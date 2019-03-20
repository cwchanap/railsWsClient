module ArticlesHelper
    def isUserMatch(article_user_id)
        curr_user = session[:curr_userid]
        article_user_id == curr_user
    end
end
