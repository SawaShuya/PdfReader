Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'homes#top'
  resources :questions
  post 'questions/create_from_pdf' => 'questions#create_from_pdf', as: 'create_from_pdf'
  post 'questions/create_collection' => 'questions#create_collection', as: 'create_collection'

  resources :subjects, only: [:index] do
    get 'backnumbers' => 'subjects#test_numbers', as: 'test_numbers'
    get 'questions' => 'subjects#questions', as: 'questions'
  end

  resources :test_subjects, only: [:show]

  resources :test_numbers, only: [:index]
  get 'test_numbers/:year/backnumbers' => 'test_numbers#subjects', as: 'test_year_subjects'
end
