Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :users

  resources :countries do
    get "select_country", to: "entities#render_select_country"
  end


  resources :companies do
    get '/invoices/add_item' , to: 'invoices#render_add_item'
    get '/invoices/add_item/:entity_id', to: "invoices#test"
    resources :entities do
      resources :returns do
        resources :transactions
      end
      
    end
    resources :returns
    resources :entity_tax_codes do
      get "select_country", to: "entities#render_select_country"
    end

    resources :invoices do
      get 'add_item', action: :index, controller: 'users'
      get "add_item", to: "invoices#render_add_item"
      get "greet", to: "invoices#test"
    end
    resources :customers
  end

  resources :returns do
    get "select_shares_sector", to: "returns#render_select_shares_sector"
    resources :entities
    get "select_shares_sector", to: "entities#render_select_shares_sector"
  end

  resources :entities do
    get "select_entities", to: "entities#render_select_entities"
    resources :countries do
      get "select_project", to: "countries#render_select_project"
      resources :project_types do
        get "select_periodicity", to: "project_types#render_select_periodicity"
      end
    end
  end

end
