class BooksController < ApplicationController
  def index
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])
    #respond_to do |format|
      render :json => @book.search_amazon 
    #end
  end

  def new
    @book = Book.new
  end

  def create
    #@book = books.build(book_param)
    @book = Book.new(params.require(:book).permit(:isbn))
    if @book.save
      redirect_to(@book, format: :json)
    else
      render('new')
    end
  end

  def book_param
    params.require(:book).permit(:isbn)
  end

end
