Knp::Engine.routes.draw do

  match '/notifications/:plugin_name', :to => 'notifications#notify', :via => [:get, :post, :put]
end
