class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :words
  has_many :quizzes

  #list all the skills in user's dictionary
  def words_in_dictionary
    words.order(created_at: :desc)
  end

  def word_in_dictionary?(term)
    if words.find_by(term: term)
      true
    else
      false
    end
  end

  def words_added_today
    words.where("created_at > ? AND created_at < ?", 1.day.ago, Time.current).order(created_at: :desc)
  end

  def words_added_yesterday
    words.where("created_at > ? AND created_at < ?", 2.days.ago, Date.current).order(created_at: :desc)
  end

  # returns the number of words in user's wordpad
  def words_count_user
    words.count
  end

  def quiz_question_word(userWordCount)
      words[rand(userWordCount - 1)]
  end

  # the first option generator will only check against the meaning of the quez question's word
  def random_meaning_generator1(userWordCount, quiz_q_word_meaning)
       meaning = words[rand(userWordCount - 1)][:meaning]

       if meaning == quiz_q_word_meaning
         random_meaning_generator1(userWordCount, quiz_q_word_meaning)
       else
         return meaning
       end
  end

  def random_meaning_generator2(userWordCount, quiz_q_word_meaning, randomgenerator1_meaning)
       meaning = words[rand(userWordCount - 1)][:meaning]

       if meaning == quiz_q_word_meaning
         random_meaning_generator2(userWordCount, quiz_q_word_meaning, randomgenerator1_meaning)
       elsif meaning == randomgenerator1_meaning
         random_meaning_generator2(userWordCount, quiz_q_word_meaning, randomgenerator1_meaning)
       else
         return meaning
       end
  end

  def random_meaning_generator3(userWordCount, quiz_q_word_meaning, randomgenerator1_meaning, randomgenerator2_meaning)
       meaning = words[rand(userWordCount - 1)][:meaning]

       if meaning == quiz_q_word_meaning
         random_meaning_generator3(userWordCount, quiz_q_word_meaning, randomgenerator1_meaning, randomgenerator2_meaning)
       elsif meaning == randomgenerator1_meaning
         random_meaning_generator3(userWordCount, quiz_q_word_meaning, randomgenerator1_meaning, randomgenerator2_meaning)
       elsif meaning == randomgenerator2_meaning
         random_meaning_generator3(userWordCount, quiz_q_word_meaning, randomgenerator1_meaning, randomgenerator2_meaning)
       else
         return meaning   
       end
  end

  # quiz conditions:
  # 5 questions
  # same word cannot be asked again in a quiz of 5 questions
  # same meaning cannot be repeated in the question

end
