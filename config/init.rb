# Go to http://wiki.merbivore.com/pages/init-rb
 
require 'config/dependencies.rb'

use_orm :datamapper
use_test :rspec
use_template_engine :haml

Merb::Config.use do |c|
  c[:use_mutex] = false
  c[:session_store] = 'datamapper'  # can also be 'memory', 'memcache', 'container', 'datamapper
  
  # cookie session store configuration
  c[:session_secret_key]  = '06c582f68ac086f4235e119236ec16da2f8d7931'  # required for cookie session store
  c[:session_id_key] = 'irc_logger_session_id' # cookie session id key, defaults to "_session_id"
  
  c[:irc_default_server] = 'irc.freenode.net'
end
 
 
Merb::BootLoader.before_app_loads do
  # This will get executed after dependencies have been loaded but before your app's classes have loaded.
  DataMapper.setup(:search, 'sphinx://localhost/./config/sphinx.conf')
  Merb::Cache.setup do
    register(:memory_store, Merb::Cache::MemcachedStore, :namespace => "irc-logger", :servers => ["127.0.0.1:11211"])
    register(:page_store, Merb::Cache::PageStore[Merb::Cache::FileStore], :dir => Merb.root / "public")
    register(:default, Merb::Cache::AdhocStore[:memory_store, :page_store])

  end
end
 
Merb::BootLoader.after_app_loads do
  # This will get executed after your app's classes have been loaded. 
end
