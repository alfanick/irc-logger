Merb.logger.info("Compiling routes...")
Merb::Router.prepare do |r|
	match('/messages/:page').to(:controller => 'messages', :action => 'index').name(:search)
  match('/messages/more/:id(/:limit)').to(:controller=>'messages', :action=>'more')
	match('/message/:id/:bcount/:count').to(:controller => 'messages', :action => 'show').name(:show_message)
  match('/logs/:host/:channel/:year/:month/:day', :host=>/[a-z.0-9_]+/i).to(:controller => 'messages', :action => 'log', :format=>'log').name(:raw_log)

  match('/guys/:page').to(:controller => 'guys', :action => 'index').name(:guys)
  match('/guy/:nickname').to(:controller => 'guys', :action => 'show', :query => '@nickname [1]').name(:show_guy)

	match('/join').to(:controller => 'channels', :action => 'new').name(:join_channel)
	match('/join/end').to(:controller => 'channels', :action => 'create').name(:create_channel)
	match('/:server/channels/:page', :server=>/[a-z.0-9_]+/i).to(:controller => 'channels', :action => 'index', :query => '@server [1]').name(:channels)
	match('/:server/:name', :server=>/[a-z.0-9_]+/i).to(:controller => 'channels', :action => 'show', :query => '@channel #[2] @server [1]').name(:show_channel)
  
	match('/servers').to(:controller => 'servers', :action => 'index').name(:servers)

  slice(:merb_auth_slice_password, :name_prefix => nil, :path_prefix => "")

  match('/about').to(:controller => 'frontend', :action => 'about').name(:about)
  match('/').to(:controller => 'frontend', :action =>'index').name(:frontend)

  default_routes
end
