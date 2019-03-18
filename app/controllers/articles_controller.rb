class ArticlesController < ApplicationController
    include Auth    
    before_action :auth

    def new
    end

    def create
        @article = Article.new(params.require(:article).permit(:title, :text))
        @article.status = true

        @article.save
        redirect_to articles_path
    end

    def update
        @article = Article.find(params[:id])
       
        if @article.update(params.require(:article).permit(:title, :text))
            redirect_to articles_path
        else
            render 'edit'
        end
    end

    def toggle
        @article = Article.find(params[:article_id])
       
        if @article.update(status: !@article.status)
            redirect_to articles_path
        else
            render 'show'
        end
    end

    def show
        @article = Article.find(params[:id])
    end

    def index
        @articles = Article.all
    end

    def edit
        @article = Article.find(params[:id])
    end

    def destroy
        @article = Article.find(params[:id])
        @article.destroy
       
        redirect_to articles_path
    end
end
