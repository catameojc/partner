Rails.application.routes.draw do
  devise_for :users

  get 'site/sha', to: 'site#sha'
  post 'transaction', to: 'checkout#transaction'
  get 'invoice', to: 'checkout#invoice'
  get 'receipt', to: 'checkout#receipt'
  get 'dns' => 'domain_hosts#dns'
  get 'invoice/month' => 'checkout#invoicemonthly'

  root 'welcome#index'

  get 'registration/search', to: 'registration#search'
  get 'registration/create_contact', to: 'registration#create_contact'
  post 'registration/confirm', to: 'registration#confirm'

  post 'contacts/:id/multiple', to: 'contacts#edit_multiple', as: 'edit_multiple_contacts'
  post 'domains/:id/multiple', to: 'domains#renew_multiple', as: 'renew_multiple_domains'

  get 'domains/:id/default_nameservers', to: 'domain_hosts#add_default_nameservers', as: 'add_default_nameserver'

  resources :domains, only: [:index, :show, :update], id: /.*/ do
    get :renew
    resources :hosts, controller: :domain_hosts, only: [:index, :create, :edit, :update, :destroy], id: /.*/
  end

  resources :hosts, only: [:index, :show]

  resources :contacts

  resources :profile, only: :index

  resources :partners, only: [:index, :show] do
    get :otc, controller: :credits, action: :new
    post :otc, controller: :credits, action: :create
  end

  resources :reports, only: :index

  resources :about, only: [] do
    collection do
      get :coc
      get :sa
    end
  end

  resources :partner, only: [:index]

  resources :activities, only: [:index]

  resources :orders, only: [:index]

  namespace :powerdns do
    resources :records
    resources :domains
  end

  get   :register, to: 'register#new'
  post  :register, to: 'register#search'

  scope path: :register, as: :register do
    get   :details, to: 'register#details'
    post  :details, to: 'register#create_registrant'

    get   :summary, to: 'register#summary'
    post  :summary, to: 'register#create_order'
  end

  resources :checkout, only: [:index] do
    collection do
      get :payment_token
      get :verify
    end
  end

  scope path: :paypal, as: :paypal do
    get :setup_payment, to: 'paypal#setup_payment'
    match :return, to: 'paypal#returns', via: [:get, :post]
    match :cancel, to: 'paypal#cancel', via: [:get, :post]
  end

  resources :credits, only: [:create]
#  scope path: :credits do
#    match :create, to: 'credits#create', via: [:get, :post], as: :credits
#  end
end
