Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :v1 do
    namespace :games do
      get 'result/:id', action: :result
      post 'create', action: :create
      post 'add_points', action: :add_points
    end
  end
end
