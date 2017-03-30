class Movie < ApplicationRecord
  belongs_to :user

  has_many :comments
  has_many :movie_relationships
  has_many :followers, through: :movie_relationships, source: :user

  validates :title, presence: true
  validates :description, presence: true
end
