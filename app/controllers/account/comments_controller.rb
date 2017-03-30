class Account::CommentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @comments = current_user.comments
  end
end
