Knp::Engine.routes.draw do

  match '/notifications/:plugin_name(/:cluster)', :to => 'notifications#notify', :via => [:get, :post, :put]
end
