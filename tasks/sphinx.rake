namespace :sphinx do
  desc 'Create main messages index (slowly)'
  task :main do
    sh 'indexer --config config/sphinx.conf messages'
  end
  
  desc 'Create delta messages index (fast - only new messages are indexed)'
  task :delta do
    sh 'indexer --config config/sphinx.conf delta'
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
      repository(s).adapter.query('DROP VIEW "Messages";')
    rescue Exception
      puts $!
    end
    begin
      repository(s).adapter.query('CREATE VIEW "Messages" AS SELECT messages.id, guys.nickname, servers.host, servers.name AS server_name, channels.name AS channel_name, messages.event, messages.content FROM (((messages JOIN guys ON (((messages.guy_nickname)::text = (guys.nickname)::text))) JOIN channels ON ((messages.channel_id = channels.id))) JOIN servers ON (((channels.server_host)::text = (servers.host)::text)));')
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
  task :restart => [:stop, :listen] do
  
  end
end
