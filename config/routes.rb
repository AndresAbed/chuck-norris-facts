Rails.application.routes.draw do
  root 'main#index'
  get '/facts', to: 'main#facts'
  get 'main/search', as: :search
  get 'main/language', as: :language

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
