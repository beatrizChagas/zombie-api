Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :users, only: %i[create update] do
        post 'transfer_items/:target_user_id', as: :transfer_items, to: 'inventories#transfer_items'

        resource :infection, only: :create
        resource :inventory, only: [] do
          member do
            post 'add_item'
            post 'remove_item'
          end
        end
      end

      resource :report, only: [] do
        get 'infected_users'
        get 'non_infected_users'
        get 'item_average_per_user'
      end
    end
  end
end
