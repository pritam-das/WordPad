class WordsController < ApplicationController
  before_action :load_user

  def new
    @user = current_user
    @word = Word.new
  end

  def create


    @user = current_user

    @word = current_user.words.build(word_params)

    if @user.word_in_dictionary?(word_params[:term])
      respond_to do |format|
        stringResponse = "#{word_params[:term]} exists in your dictionary already!"
        format.json {render json: stringResponse.to_json}
      end

    else
      @word.save
      respond_to do |format|

        format.html do
          redirect_to users_dictionary_path
        end

        format.json {render json: @word}
      end
    end


  end

  def flash_meaning

    client = OxfordDictionary::Client.new(app_id: '0cd7449e', app_key: 'ae4b0f3d52fb1ce1b612f9b93c85a0f6')
    client = OxfordDictionary.new(app_id: '0cd7449e', app_key: 'ae4b0f3d52fb1ce1b612f9b93c85a0f6')

    @word = Word.new(
      term: word_params[:term],
      meaning: client.entry(word_params[:term])[:lexical_entries].entries[0].entries[0].senses[0].definitions[0],
      user_id: current_user.id
    )

    respond_to do |format|
      format.json {render json: @word}
    end



  end

  def destroy

  end



  private

  def word_params
    params.require(:word).permit(:term, :meaning, :user_id)
  end

  def load_user
    @user = current_user
  end
end
