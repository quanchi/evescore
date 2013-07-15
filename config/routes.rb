Evescore::Application.routes.draw do
  get "blitz/test"
  
  get "rats/show"

  get '/mu-70933399-cf59f263-41132851-471e4059', :controller => :blitz, :action => :test do
    '42'
  end
  get "corp/profile"

  get "info/about"

  get "info/faq"

  get "info/changelog"
  
  get "info/contact"

  get "character/profile"
  get "character/all"

  match "/donate", :controller => :donate, :action => :index

  get "kills/log"
  get "/ladder", :controller => :kills, :action => :ladder

  get "api/verify"
  get "api/import_all"
  match "api/import"

  get "key/add"
  match "key/save"
  
  match "/irs", :controller => :home, :action => :taxes
  
  root :to => "home#index"
end
