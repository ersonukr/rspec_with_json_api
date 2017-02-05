class BooksController < ApplicationController
  before_action :set_user
  before_action :set_user_book, only: [:show, :update, :destroy]

  # GET /books
  def index
    json_response(@user.books)
  end

  # GET /books/1
  def show
    json_response(@book)
  end

  # POST /books
  def create
    @user.books.create!(book_params)
    json_response(@user, :created)
  end

  # PATCH/PUT /books/1
  def update
    @book.update(book_params)
    head :no_content
  end

  # DELETE /books/1
  def destroy
    @book.destroy
  end

  private

  # Only allow a trusted parameter "white list" through.
  def book_params
    params.permit(:title, :description, :user_id)
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_user_book
    @book = @user.books.find_by!(id: params[:id]) if @user
  end
end
