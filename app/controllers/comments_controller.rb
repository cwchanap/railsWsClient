class CommentsController < ApplicationController
    include Auth    
    before_action :auth
    
    def create
        @article = Article.find(params[:article_id])
        comment = @article.comments.create(comment_params)
        comment.user_id = session[:curr_userid]
        comment.save
        redirect_to article_path(@article)
    end

    def new
        @article = Article.find(params[:article_id])
    end
    
    private
        def comment_params
            params.require(:comment).permit(:body)
        end
end