DuneOnline::Application.routes.draw do
  resources :posts

  resources :topics

  resources :syselaads
  get 'syselaad/:kind' => 'syselaads#show', :as => :syselaad

  resources :laws

  resources :polls

  resources :operations

  resources :eods
  match 'zobraz_eod' => 'eods#zobraz_eod', :as => :zobraz_eod

  resources :systems

  resources :votes

  resources :planet_types

  resources :effects

  resources :buildings

  resources :fields
  match 'prejmenuj_pole' => 'fields#prejmenuj_pole', :as => :prejmenuj_pole
  match 'postavit_budovu' => 'fields#postavit_budovu', :as => :postavit_budovu
  match 'postavit_arrakis' => 'fields#postavit_arrakis', :as => :postavit_arrakis

  resources :properties

  resources :planets
  match 'list_osidlitelnych' => 'planets#list_osidlitelnych', :as => :list_osidlitelnych
  match 'osidlit_pole' => 'planets#osidlit_pole', :as => :osidlit_pole
  match 'zobraz_arrakis' => 'planets#zobraz_arrakis', :as => :zobraz_arrakis

  resources :subhouses

  resources :houses
  match 'kolonizuj' => 'houses#kolonizuj', :as => :kolonizuj
  match 'sprava_rod' => 'houses#sprava_rod', :as => :sprava_rod
  match 'posli_rodove_suroviny' => 'houses#posli_rodove_suroviny', :as => :posli_rodove_suroviny

  resources :discoverables
  
#  match 'user/edit' => 'users#edit', :as => :edit_current_user

  match 'signup' => 'users#new', :as => :signup

  match 'logout' => 'sessions#destroy', :as => :logout

  match 'login' => 'sessions#new', :as => :login

  resources :sessions

  resources :users
  match 'zmen_prava' => 'users#zmen_prava', :as => :zmen_prava
  match 'hlasovat' => 'users#hlasovat', :as => :hlasovat
  match 'sprava' => 'users#sprava', :as => :sprava
  match 'pridel_pravo' => 'users#pridel_pravo', :as => :pridel_pravo
  match 'odeber_pravo' => 'users#odeber_pravo', :as => :odeber_pravo
  match 'posli_suroviny' => 'users#posli_suroviny', :as => :posli_suroviny

#  resources :admin
  match 'prepni_prihlasovani' => 'admin#prepni_povoleni_prihlasovani'
  match 'prepni_zakladani' => 'admin#prepni_povoleni_zakladani'
  match 'zamkni_hru' => 'admin#zamkni_hru', :as => :zamkni_hru
  match 'prepocti_vliv' => 'admin#prepocti_vliv', :as => :prepocti_vliv
  match 'kompletni_prepocet' => 'admin#kompletni_prepocet', :as => :kompletni_prepocet
  match 'pridej_suroviny' => 'admin#pridej_suroviny', :as => :pridej_suroviny
  match 'global_index' => 'admin#global_index', :as => :global_index
  match 'update_global/:id' => 'admin#update_global', :as => :global
  match 'sweep_session' => 'admin#sweep_session', :as => :sweep_session
  
  match 'show' => 'imperium#show', :as => :imperium
  match 'sprava_imperia' => 'imperium#sprava', :as => :sprava_imperia
  match 'posli_imperialni_suroviny' => 'imperium#posli_imperialni_suroviny', :as => :posli_imperialni_suroviny

  match 'landsraad_show' => 'landsraad#show', :as => :landsraad_show
  match 'landsraad_jednani' => 'landsraad#jednani', :as => :landsraad_jednani
  match 'volba_imperatora' => 'landsraad#volba_imperatora', :as => :volba_imperatora
  
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'sessions#new'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
