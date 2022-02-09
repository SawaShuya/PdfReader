Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'questions#index'
  resources :questions
  post 'questions/create_from_pdf' => 'questions#create_from_pdf', as: 'create_from_pdf'
end
