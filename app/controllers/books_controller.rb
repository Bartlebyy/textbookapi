class BooksController < ApplicationController
  def index
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])
    #respond_to do |format|
    # json_output = {attributes: @book.get_book_attributes, amz_search: @book.search_amazon}
    # render :json => json_output
    #end
  end

  def new
    @book = Book.new
  end

  def create
    #@book = books.build(book_param)
    @book = Book.new(params.require(:book).permit(:isbn))
    if @book.save
      json_output = {attributes: @book.get_book_attributes, amz_search: @book.search_amazon}
      render :json => json_output
    else
      render('new')
    end
  end

  def book_param
    params.require(:book).permit(:isbn)
  end

end
