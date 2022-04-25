class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:update, :edit]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
    @books_today = Book.where(user_id: params[:id], created_at: Time.zone.now.all_day)
    @books_yesterday = Book.where(user_id: params[:id], created_at: 1.day.ago.all_day)
    @books_2daysAgo = Book.where(user_id: params[:id], created_at: 2.day.ago.all_day)
    @books_3daysAgo = Book.where(user_id: params[:id], created_at: 3.day.ago.all_day)
    @books_4daysAgo = Book.where(user_id: params[:id], created_at: 4.day.ago.all_day)
    @books_5daysAgo = Book.where(user_id: params[:id], created_at: 5.day.ago.all_day)
    @books_6daysAgo = Book.where(user_id: params[:id], created_at: 6.day.ago.all_day)

    gon.data = [
      @books_6daysAgo.count,
      @books_5daysAgo.count,
      @books_4daysAgo.count,
      @books_3daysAgo.count,
      @books_2daysAgo.count,
      @books_yesterday.count,
      @books_today.count
    ]

    if @books_yesterday.count == 0
      @books_dayRatio = @books_today.count * 100
    else
      @books_dayRatio = @books_today.count / @books_yesterday.count * 100
    end

    # 今週分
    to_thisWeek  = Time.zone.now.end_of_day
    from_thisWeek    = 6.days.ago.beginning_of_day
    @books_thisWeek = Book.where(user_id: params[:id], created_at: from_thisWeek..to_thisWeek)

    # 先週分
    to_lastWeek  = 1.week.ago.end_of_day
    from_lastWeek    = 13.days.ago.beginning_of_day
    @books_lastWeek = Book.where(user_id: params[:id], created_at: from_lastWeek..to_lastWeek)

    if @books_lastWeek.count == 0
      @books_weekRatio = @books_thisWeek.count * 100
    else
      @books_weekRatio = @books_thisWeek.count / @books_lastWeek.count * 100
    end
  end

  def books_search
    # 何も入力がなかったら今日の投稿を検索
    if params[:created_date] == ""
      @books_search = Book.where(user_id: params[:user_id], created_at: Time.zone.now.all_day)
    else
      @books_search = Book.where(user_id: params[:user_id], created_at: params[:created_date].in_time_zone.all_day)
    end
  end

  def index
    @users = User.all
    @book = Book.new
    @books = Book.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to users_path(@user.id), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
