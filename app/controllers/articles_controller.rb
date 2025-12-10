class ArticlesController < ApplicationController
  include Auth

  before_action :auth

  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
  end

  def new; end

  def edit
    @article = Article.find(params[:id])
  end

  def create
    @user = User.find_by(id: session[:curr_userid])
    @article = @user.articles.create!(article_params)
    @article.status = true

    @article.save
    redirect_to articles_path
  end

  def update
    @article = Article.find(params[:id])

    if @article.update(params.expect(article: %i[title text]))
      redirect_to articles_path
    else
      render "edit"
    end
  end

  def toggle
    @article = Article.find(params[:article_id])

    if @article.update(status: !@article.status)
      redirect_to articles_path
    else
      render "show"
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    redirect_to articles_path
  end

  private

  def article_params
    params.expect(article: %i[title text])
  end
end
