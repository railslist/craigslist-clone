ActionController::Routing::Routes.draw do |map|

  map.resource :user  
  map.resources :cities, :categories, :subcategories, :classifieds

  #main    
  map.root :controller => "main"

  # route for simple captcha
  map.simple_captcha '/simple_captcha/:action', :controller => 'simple_captcha'

  #admin logout  
  map.connect '/logout', :controller=>'users', :action=>'destroy'
  
  
  map.connect '/adminsearch', :controller=>'classifieds', :action=>'adminsearch'
  
  #search
  map.connect '/mainsearch', :controller=>'main', :action=>'mainsearch'
  map.connect '/:permalink_1/categorysearch', :controller=>'main', :action=>'categorysearch'

  map.connect '/contactadvertiser', :controller=>'main', :action=>'contactadvertiser'
  
  #city page
  map.connect '/:permalink_1', :controller => 'main', :action => 'city'
  
  #activate, edit classifieds
  map.activate '/activate/:activation_code', :controller => 'main', :action => 'activate'
  map.edit '/edit/:activation_code', :controller => 'classifieds', :action => 'edit'
  map.update '/update/:activation_code', :controller => 'classifieds', :action => 'update'
  map.delete '/delete/:activation_code', :controller => 'classifieds', :action => 'destroy'
  map.connect '/classifieds/multidelete', :controller=>'classifieds', :action=>'delete_multiple'
    
  #category page
  map.connect '/:permalink_1/:permalink_2', :controller => 'main', :action => 'category'
  
  #ad page
  map.connect '/:permalink_1/:permalink_2/:permalink_3', :controller => 'classifieds', :action => 'show'
  
  map.connect '*path', :controller => 'main'
end
