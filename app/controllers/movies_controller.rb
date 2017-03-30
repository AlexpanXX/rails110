class MoviesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edti, :update, :destroy]
  before_action :find_movie_and_check_permission, only: [:edit, :update, :destroy]

  def index
    @movies = Movie.all
  end

  def show
    @movie = Movie.find(params[:id])
    @comments = @movie.comments
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new(movie_params)
    @movie.user = current_user

    if @movie.save
      current_user.favorite!(@movie)
      redirect_to movies_path
    else
      render :new
    end
  end

  def update
    if @movie.update(movie_params)
      redirect_to movies_path, notice: "Movie successfully updated!"
    else
      render :edit
    end
  end

  def destroy
    @movie.destroy
    redirect_to movies_path, alert: "Movie deleted."
  end

  def favorite
    @movie = Movie.find(params[:id])
    if !current_user.is_follower_of?(@movie)
      current_user.favorite!(@movie)
      flash[:notice] = "收藏电影成功！"
    else
      flash[:warning] = "您已经收藏过这部电影！"
    end
    redirect_to movie_path(@movie)
  end

  def dislikes
    @movie = Movie.find(params[:id])
    if current_user.is_follower_of?(@movie)
      current_user.dislikes!(@movie)
      flash[:alert] = "已取消收藏电影！"
    else
      flash[:warning] = "您没有收藏这部电影，怎么取消收藏 XD"
    end
    redirect_to movie_path(@movie)
  end

  private

  def find_movie_and_check_permission
    @movie = Movie.find(params[:id])
    if @movie.user != current_user
      redirect_to root_path, alert: "You have no permission."
    end
  end

  def movie_params
    params.require(:movie).permit(:title, :description)
  end
end
