Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :clubs, only: %i[show index create update destroy] do
    resources :members, only: %i[show index create update destroy]
  end
  post 'result_draw', :to => 'clubs#result_draw'
  post 'result_win', :to => 'clubs#result_win'
end
