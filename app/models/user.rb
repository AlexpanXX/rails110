class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :comments
  has_many :movie_relationships
  has_many :favorited_movies, through: :movie_relationships, source: :movie

  def is_follower_of?(movie)
    favorited_movies.include?(movie)
  end

  def favorite!(movie)
    favorited_movies << movie
  end

  def dislikes!(movie)
    favorited_movies.delete(movie)
  end
end
