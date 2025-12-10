Rails.application.routes.draw do
  post "login/new"
  delete "login/destroy"

  get "admin/index"
  get "heaven" => "main#heaven"

  resources :articles do
    resources :comments
    get "toggle" => "articles#toggle"
  end

  resources :user do
    get "mail" => "user#mail"
  end
  get "validate" => "user#validate"

  root "login#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
