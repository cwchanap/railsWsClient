class CommentsController < ApplicationController
  include Auth

  before_action :auth

  def new
    @article = Article.find(params[:article_id])
  end

  def create
    @article = Article.find(params[:article_id])
    comment = @article.comments.create(comment_params)
    comment.user_id = session[:curr_userid]
    comment.save
    redirect_to article_path(@article)
  end

  private

  def comment_params
    params.expect(comment: [:body])
  end
end
