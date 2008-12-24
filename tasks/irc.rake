namespace :irc do
  def parse_channel_and_server(url)
    args = url.split('/')
    # passed server and channel (irc.freenode.net/hacking)
    if args.size == 2 
      server = args[0]
      channel = args[1]
      channel = '#' + channel if not channel =~ /^#/
    # passed server only (irc.freenode.net)
    else
      server = args[0]
      channel = nil
    end
    
    return server, channel
  end

  desc 'Join channel given by url'
  task :join, [:url] => [:merb_env] do |t, a|
    server, channel = parse_channel_and_server(a.url)

    # get a server or create new
    sv = Server.first_or_create(:host => server)
    # enable the server and save it
    sv.status = :enabled
    sv.save or raise 'Check the url!'
    
    # get a channel or create new
    ch = Channel.first(:name => channel, 'server.host' => server) \
          || Channel.new(:name => channel, :server => sv)
    # enable the channel and save it
    ch.status = :enabled
    ch.save or raise 'Check the url!'
    
    Merb.logger.info "Joined #{ch.name} at #{sv.name}"
  end
  
  desc 'Leave channel given by url'
  task :leave, [:url] => [:merb_env] do |t, a|
    server, channel = parse_channel_and_server(a.url)
  
    ch = Channel.first(:name => channel, 'server.host' => server)
    ch.status = :disabled
    ch.save or raise 'Check the url!'
  
    Merb.logger.info "Left #{ch.name} at #{ch.server.name}"
  end
  
  desc 'List everything in url'
  task :status, [:url] => [:merb_env] do |t, a|
    server, channel = parse_channel_and_server(a.url)
    
    if server and not channel
      sv = Server.first(:name => server)
      
      puts "Server #{sv.name} (#{sv.status}):"
      
      sv.channels.each do |ch|
        msg = '  '
        case ch.status
          when :enabled : msg += '+'
          when :disabled: msg += '-'
          when :inactive: msg += '?'
        end
        
        msg += " #{ch.name} (#{ch.created_at})"
        
        puts msg
      end
    else
      ch = Channel.first(:name => channel, 'server.host' => server)
      
      puts "Channel #{ch.name} at #{ch.server.name} is #{ch.status}"
    end
  end
  
  desc 'Listen for messages'
  task :listen => [:merb_env, 'irc:clean'] do
    require 'the_logger/supervisor'
    
    config = YAML::load_file('config/bot.yml')
    
    sv = TheLogger::Supervisor.new(config['server'], config['listeners'])
    
    Merb.logger.info "Listening for messages..."
    
    sv.start
  end
  
  desc 'Stop listening'
  task :stop => [:merb_env] do
    require 'the_logger/supervisor'
    
    config = YAML::load_file('config/bot.yml')
    
    sv = TheLogger::Supervisor.new(config['server'], config['listeners'])
    
    Merb.logger.info "Stopped listening..."
    
    sv.stop
  end
  
  desc 'Create listener'
  task :listener, [:name] => [:merb_env] do |t, a|
    raise "You must pass listener name" unless a.name
    
    require 'the_logger/listener'
    
    config = YAML::load_file('config/bot.yml')
    
    Merb.logger.info "Created listener..."
    
    l = TheLogger::Listener.new(config['server'], a.name)
    l.run
  end
  
  desc 'Clean queues'
  task :clean => [:merb_env] do |t, a|
    require 'the_logger/supervisor'
    
    config = YAML::load_file('config/bot.yml')
    
    sv = TheLogger::Supervisor.new(config['server'], config['listeners'])
    
    Merb.logger.info "Cleaned queues..."
    
    sv.clean
  end
end
