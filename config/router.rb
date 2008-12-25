Merb.logger.info("Compiling routes...")
Merb::Router.prepare do |r|
  resources :servers
  
  match('/guys/:page').to(:controller => 'guys', :action => 'index').name(:guys)
  match('/guy/:nickname').to(:controller => 'guys', :action => 'show').name(:show_guy)

	match('/channels/:page').to(:controller => 'channels', :action => 'index').name(:channels)
	match('/channels/:name').to(:controller => 'channels', :action => 'show').name(:show_channel)
  
  match('/messages/:page').to(:controller => 'messages', :action => 'index').name(:search)
  match('/message/:id/:bcount/:count').to(:controller => 'messages', :action => 'show').name(:show_message)
  match('/logs/:host/:channel/:year/:month/:day', :host=>/[a-z.0-9_]+/i).to(:controller => 'messages', :action => 'log', :format=>'log').name(:raw_log)
  
  
  
  slice(:merb_auth_slice_password, :name_prefix => nil, :path_prefix => "")

  default_routes

  match('/about').to(:controller => 'frontend', :action => 'about').name(:about)
  match('/').to(:controller => 'frontend', :action =>'index').name(:frontend)
end
