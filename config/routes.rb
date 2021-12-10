Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html



  resources :users

  resources :countries do
    get "select_country", to: "entities#render_select_country"
  end

# english
  resources :companies do
    
    get '/invoices/add_item/:entity_id', to: "invoices#render_add_item"
    get '/invoices/:invoice_id/add_ticket', to: "invoices#add_ticket"
    get '/invoices/:invoice_id/save_ticket', to: "invoices#save_ticket"    
    get '/invoices/:invoice_id/paid', to: "invoices#paid"
    get '/invoices/:invoice_id.generate_pdf', to: "invoices#generate_pdf"

    # Delete Invoice
    get '/invoices/:invoice_id/delete_invoice', to: "invoices#delete_invoice"

    # Add transaction to invoice
    get '/invoices/:invoice_id/add_transaction', to: "invoices#add_transaction"
    get '/invoices/:invoice_id/add_photo', to: "invoices#add_photo"
    get '/invoices/:invoice_id/save_transaction', to: "invoices#save_transaction"
    get '/invoices/:invoice_id/save_photo', to: "invoices#save_photo"

    # Delete invoice
    get '/invoices/:invoice_id/delete_transaction', to: "invoices#delete_transaction"

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
      get '/transactions/:transaction_id/edit_ticket_invoice', to: "transactions#edit_ticket_invoice"
      get '/transactions/:transaction_id/save_transaction_invoice', to: "transactions#save_transaction_invoice"
      get '/transactions/:transaction_id/save_ticket_invoice', to: "transactions#save_ticket_invoice"

      # Remove transaction from Invoice Screen
      get '/transactions/:transaction_id/delete_transaction', to: "transactions#delete_transaction"



      resources :transactions
    end

    resources :customers

    # Delete Customer from customer index form
    get '/customers/:customer_id/delete', to: 'customers#delete'

    resources :items

    # Edit Item from edit form
    get '/items/:item_id/update_item', to: "items#update_item"

    
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

# French
  #company
  get '/entreprises/new', to: "companies#new_french"
  get '/entreprises/:company_id', to: "companies#show_french"

  #entity
  get '/entreprises/:company_id/entites/new', to: "entities#new_french"
  get '/entreprises/:company_id/entites/create', to: "entities#create_french"
  get '/entreprises/:company_id/entites/:entity_id', to: "entities#show_french"
  get '/entreprises/:company_id/entites/:entity_id/edit', to: "entities#edit_french"
  get '/entreprises/:company_id/entites/:entity_id/update', to: "entities#udpate_french"

  #Invoice
  get '/entreprises/:company_id/factures', to: "invoices#index_french"
  get '/entreprises/:company_id/factures/new', to: "invoices#new_french"
  get '/entreprises/:company_id/factures/create', to: "invoices#create_french"
  get '/entreprises/:company_id/factures/:invoice_id', to: "invoices#show_french"
  get '/entreprises/:company_id/factures/:invoice_id/edit', to: "invoices#edit_french"
  get '/entreprises/:company_id/factures/:invoice_id/update', to: "invoices#update_french"
  get '/entreprises/:company_id/factures/:invoice_id/paid', to: "invoices#paid_french"
  get '/entreprises/:company_id/factures/:invoice_id.generate_pdf', to: "invoices#generate_french_pdf"
  get '/entreprises/:company_id/factures/:invoice_id/delete_invoice', to: "invoices#delete_invoice_french"
  # create invoice with transaction
  get '/entreprises/:company_id/factures/add_item/:entity_id' , to: "invoices#render_add_item_french"

  # Transaction
  get '/entreprises/:company_id/factures/:invoice_id/add_transaction', to: "invoices#add_transaction_french"
  get '/entreprises/:company_id/factures/:invoice_id/add_item/:entity_id' , to: "invoices#render_add_item_french"
  get '/entreprises/:company_id/factures/:invoice_id/save_transaction', to: "invoices#save_transaction_french"
  get '/entreprises/:company_id/factures/:invoice_id/transactions/:transaction_id/edit_transaction_invoice', to: "transactions#edit_transaction_french_invoice"
  get '/entreprises/:company_id/factures/:invoice_id/transactions/:transaction_id/save_transaction_invoice', to: "transactions#save_transaction_french_invoice"
  get '/entreprises/:company_id/factures/:invoice_id/transactions/:transaction_id/delete_transaction', to: "transactions#delete_transaction_french"

  # Customer
  get '/entreprises/:company_id/clients', to: 'customers#index_french'
  get '/entreprises/:company_id/clients/new', to: 'customers#new_french'
  get '/entreprises/:company_id/clients/create', to: 'customers#create_french'
  get '/entreprises/:company_id/clients/:customer_id/edit', to: 'customers#edit_french'
  get '/entreprises/:company_id/clients/:customer_id/update', to: 'customers#update_french'
  # too dangerous, can break all invoice & co
  get '/entreprises/:company_id/clients/:customer_id/delete', to: 'customers#delete_french'


  # Items
  get '/entreprises/:company_id/articles', to: 'items#index_french'
  get '/entreprises/:company_id/articles/new', to: 'items#new_french'
  get '/entreprises/:company_id/articles/create', to: 'items#create_french'
  get '/entreprises/:company_id/articles/:item_id/edit', to: 'items#edit_french'
  get '/entreprises/:company_id/articles/:item_id/update', to: 'items#update_french'

  # Dashboard
  get '/entreprises/:company_id/dashboard', to: 'dashboard#index_french'
end


