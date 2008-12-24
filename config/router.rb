# Merb::Router is the request routing mapper for the merb framework.
#
# You can route a specific URL to a controller / action pair:
#
#   match("/contact").
#     to(:controller => "info", :action => "contact")
#
# You can define placeholder parts of the url with the :symbol notation. These
# placeholders will be available in the params hash of your controllers. For example:
#
#   match("/books/:book_id/:action").
#     to(:controller => "books")
#   
# Or, use placeholders in the "to" results for more complicated routing, e.g.:
#
#   match("/admin/:module/:controller/:action/:id").
#     to(:controller => ":module/:controller")
#
# You can specify conditions on the placeholder by passing a hash as the second
# argument of "match"
#
#   match("/registration/:course_name", :course_name => /^[a-z]{3,5}-\d{5}$/).
#     to(:controller => "registration")
#
# You can also use regular expressions, deferred routes, and many other options.
# See merb/specs/merb/router.rb for a fairly complete usage sample.

Merb.logger.info("Compiling routes...")
Merb::Router.prepare do |r|
  resources :servers
  resources :channels

  
  match('/guys/:page').to(:controller => 'guys', :action => 'index').name(:guys)
  match('/guy/:nickname').to(:controller => 'guys', :action => 'show').name(:show_guy)
  
  match('/messages/:page').to(:controller => 'messages', :action => 'index').name(:search)
  match('/message/:id/:bcount/:count').to(:controller => 'messages', :action => 'show').name(:show_message)
  match('/logs/:host/:channel/:year/:month/:day', :host=>/[a-z.0-9_]+/i).to(:controller => 'messages', :action => 'log', :format=>'log').name(:raw_log)
  
  
  
  slice(:merb_auth_slice_password, :name_prefix => nil, :path_prefix => "")

  default_routes

  match('/about').to(:controller => 'frontend', :action => 'about').name(:about)
  match('/').to(:controller => 'frontend', :action =>'index').name(:frontend)
end
