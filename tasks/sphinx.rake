namespace :sphinx do
  desc 'Create main messages index (slowly)'
  task :main => ['sphinx:clear_cache'] do
    begin
      sh 'indexer --config config/sphinx.conf messages'
    rescue Exception
      sh 'indexer --config config/sphinx.conf messages --rotate'    
    end
  end

	desc 'Clear action cache'
	task :clear_cache do
		sh "rm -R #{Merb.root / :tmp / :actions}"
	end
  
  desc 'Create delta messages index (fast - only new messages are indexed)'
  task :delta => ['sphinx:clear_cache'] do
    begin
      sh 'indexer --config config/sphinx.conf delta'
    rescue Exception
      sh 'indexer --config config/sphinx.conf delta --rotate'    
    end
  end
  
  desc 'Merge delta and main indexes'
  task :merge do
    sh 'indexer --config config/sphinx.conf --merge messages delta --rotate'
  end
  
  desc 'Setup Sphinx - setup folders and database'
  task :setup => [:merb_env] do
    sh 'rm -R ./var/sphinx'
    sh 'mkdirhier ./var/sphinx'
    
    s = :default
    
    begin
      repository(s).adapter.query('DROP VIEW "MessagesView";')
    rescue Exception
      puts $!
    end
    begin
      repository(s).adapter.query('CREATE VIEW "MessagesView" AS SELECT messages.id AS id, guys.nickname AS nickname, servers.host AS host, servers.name AS server, channels.name AS channel, messages.event AS event, messages.content AS content FROM (((messages JOIN guys ON (((messages.guy_nickname)::text = (guys.nickname)::text))) JOIN channels ON ((messages.channel_id = channels.id))) JOIN servers ON (((channels.server_host)::text = (servers.host)::text)));')
    rescue Exception
      puts $!
    end
    begin
      repository(s).adapter.query('DROP TABLE public.sph_messages;')
    rescue Exception
      puts $!
    end
    begin
      repository(s).adapter.query('DROP SEQUENCE public.sph_messages_id_seq;')
    rescue Exception
      puts $!
    end
    begin
      repository(s).adapter.query('CREATE TABLE sph_messages ( id integer NOT NULL, max_id integer);')
    rescue Exception
      puts $!
    end
    begin
      repository(s).adapter.query('CREATE SEQUENCE sph_messages_id_seq INCREMENT BY 1 NO MAXVALUE NO MINVALUE CACHE 1;')
    rescue Exception
      puts $!
    end
    
  end
  
  desc 'Start listening'
  task :listen do
    sh 'searchd --config config/sphinx.conf'
  end
  
  desc 'Stop listening'
  task :stop do
    sh 'searchd --config config/sphinx.conf --stop'
  end
  
  desc 'Restart listener'
  task :restart => [:stop, :listen] { }
end
