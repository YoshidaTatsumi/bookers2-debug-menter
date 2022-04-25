class BookCommentsController < ApplicationController
  def create
    @book = Book.find(params[:book_id])
    @user = @book.user
    comment = current_user.book_comments.new(book_comment_params)
    comment.book_id = @book.id
    @book_comments = @book.book_comments
    if comment.save
      # flash[:success] = "Comment was successfully created."
      # redirect_to request.referer
    else
      render '/books/show'
    end
  end

  def destroy
    @book_comment = BookComment.find(params[:id])
    @book = @book_comment.book
    if @book_comment.user != current_user
      redirect_to request.referer
    end
    @book_comment.destroy
    # redirect_to request.referer
  end

  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end
end
