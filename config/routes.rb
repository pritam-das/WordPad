Rails.application.routes.draw do
  get 'users/dictionary'
  root 'users#dictionary'
  get 'users/edit'
  get 'users/update'
  get 'words/flash_meaning'
  get 'users/sort_list'
  get 'quizzes/retrieve_word_and_meaning'
  get 'quizzes/previous_quiz_results'

  devise_for :users

  resources :users do
    resources :quizzes
    resources :words
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
