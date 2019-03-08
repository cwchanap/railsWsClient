Rails.application.routes.draw do
    get 'main/index'
    resources :articles do
        resources :comments
        get 'toggle' => 'articles#toggle'
    end
    root 'main#index'
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
