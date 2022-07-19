Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :companies, only: [:index, :create, :update, :destroy, :show]
      resources :groups, only: [:index, :create, :update, :destroy, :show] do
        collection do
          get :group_list
        end
      end
      resources :users, only: [:index, :create, :update, :destroy, :show] do
        collection do
          post :assign_group
        end
      end
    end
  end
  mount Rswag::Ui::Engine => '/'
  mount Rswag::Api::Engine => '/'
end
