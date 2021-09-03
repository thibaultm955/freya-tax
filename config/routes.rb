Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html



  resources :users

  resources :countries do
    get "select_country", to: "entities#render_select_country"
  end


  resources :companies do
    
    get '/invoices/add_item/:entity_id', to: "invoices#render_add_item"
    get '/invoices/:invoice_id.generate_pdf', to: "invoices#generate_pdf"

    # Add transaction to invoice
    get '/invoices/:invoice_id/add_transaction', to: "invoices#add_transaction"
    get '/invoices/:invoice_id/save_transaction', to: "invoices#save_transaction"


    get '/invoices/:invoice_id/add_item/:entity_id' , to: "invoices#render_add_item"
    resources :entities do
      get '/get_items_entity', to: "entities#render_items_entity"
      resources :returns do
        resources :transactions
      end

    end
    resources :returns
    resources :entity_tax_codes do
      get "select_country", to: "entities#render_select_country"
    end

    resources :invoices do
      # Update Transaction from Invoice Screen
      get '/transactions/:transaction_id/edit_transaction_invoice', to: "transactions#edit_transaction_invoice"
      get '/transactions/:transaction_id/save_transaction_invoice', to: "transactions#save_transaction_invoice"

      


      resources :transactions
    end

    resources :customers

    resources :items
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
