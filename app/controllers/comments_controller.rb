class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_comment_and_check_permission, only: [:edit, :update, :destroy]

  def new
    @movie = Movie.find(params[:movie_id])
    if !current_user.is_follower_of?(@movie)
      redirect_to movie_path(@movie), warning: "您必须关注影片后，才能发表评论！"
    end
    @comment = Comment.new
  end

  def edit
    @movie = @comment.movie
  end

  def create
    @movie = Movie.find(params[:movie_id])
    @comment = Comment.new(comment_params)
    @comment.movie = @movie
    @comment.user = current_user

    if @comment.save
      redirect_to movie_path(@movie)
    else
      render :new
    end
  end

  def update
    if @comment.update(comment_params)
      redirect_to account_comments_path, notice: "Comment Updated."
    else
      render :edit
    end
  end

  def destroy
    @comment.destroy
    redirect_to account_comments_path, alert: "Comment deleted."
  end

  private

  def find_comment_and_check_permission
    @comment = Comment.find(params[:id])
    if current_user != @comment.user
      redirect_to root_path, alert: "You have no permission."
    end
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
