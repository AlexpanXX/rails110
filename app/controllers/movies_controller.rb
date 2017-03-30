class MoviesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edti, :update, :destroy]
  before_action :find_movie_and_check_permission, only: [:edit, :update, :destroy]

  def index
    @movies = Movie.all
  end

  def show
    @movie = Movie.fins(params[:id])
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new(movie_params)
    @movie.user = current_user

    if @movie.save
      redirect_to moives_path
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
