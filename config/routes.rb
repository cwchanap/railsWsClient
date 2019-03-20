Rails.application.routes.draw do
  post 'login/new'
  delete 'login/destroy'

  get 'admin/index'

  resources :articles do
      resources :comments
      get 'toggle' => 'articles#toggle'
  end

  resources :user do
    
  end

  root 'login#index'
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
