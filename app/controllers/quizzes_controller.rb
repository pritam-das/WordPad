class QuizzesController < ApplicationController

  $questions = [1]
  # $count = 0

  def new
    $questions.clear
    $questions << '1'
    @user = current_user
    # @quiz = Quiz.new
  end

  def create
      $questions.clear
      $questions << '1'
      @user = current_user
      @quiz = @user.quizzes.build(quiz_params)

      if @quiz.save
        respond_to do |format|

          format.html do

          end
          format.json {render json: @quiz}
        end
      end

  end


  def retrieve_word_and_meaning

      @user = current_user
      # @quiz = Quiz.new

      user_word_count = @user.words_count_user

      return_word = @user.quiz_question_word(user_word_count)

      # check whether the word has been asked in the quiz

      question_asked = check_if_question_asked(return_word[:term])

        if question_asked == true
          puts 'q asked before'
          return retrieve_word_and_meaning()
        else
          return_word_term = return_word[:term]
          $questions << return_word_term
        end


      # return_word_term = return_word[:term]
      return_word_meaning = return_word[:meaning]

      randomgenerator1_meaning = @user.random_meaning_generator1(user_word_count, return_word_meaning)
      randomgenerator2_meaning = @user.random_meaning_generator2(user_word_count, return_word_meaning, randomgenerator1_meaning)
      randomgenerator3_meaning = @user.random_meaning_generator3(user_word_count, return_word_meaning, randomgenerator1_meaning, randomgenerator2_meaning)

      # puts $count
      puts $questions

      @list_of_meanings = [
        return_word_term,
        return_word_meaning,
        randomgenerator1_meaning,
        randomgenerator2_meaning,
        randomgenerator3_meaning
      ]


      respond_to do |format|
        format.html
        format.json {render json: @list_of_meanings}
      end

  end

  def check_if_question_asked(return_word)
    $questions.each do |q|
      if q == return_word
        return true
      end
    end
  end

  def previous_quiz_results
    @user = current_user
    @quizzes = @user.quizzes.all

    respond_to do |format|
      format.json {render json: @quizzes}
    end

  end

  private

  def quiz_params
    params.require(:quiz).permit(:score, :user_id)
  end

  # def fetch_word
  #   @user = current_user
  #
  #   baseword =
  # end
end
