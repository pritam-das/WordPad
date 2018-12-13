class UsersController < ApplicationController

  def show
  end

  def index
  end

  def edit
    @user = User.find(current_user.id)
  end

  def dictionary
    if current_user
      @user = User.find(current_user.id)
      @word = Word.new
      @words = @user.words_in_dictionary
    end
  end

  def sort_list
    @user = current_user
    list_value = params[:value]

    if list_value == "addedToday"
      @wordstoday = @user.words_added_today

      respond_to do |format|
        format.json {render json: @wordstoday}
      end

    elsif list_value == "addedYesterday"
        @wordsyesterday = @user.words_added_yesterday

        respond_to do |format|
          format.json {render json: @wordsyesterday}
        end

    else
      @wordsdictionary = @user.words_in_dictionary
        respond_to do |format|
          format.json {render json: @wordsdictionary}
        end
    end
  end

  def update
  end
end
