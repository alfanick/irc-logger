def parse_channel_and_server(args)
  server = args.server || Merb::Config[:irc_default_server]
  begin
    if args.channel =~ /^#/
      channel = args.channel
    else
      channel = '#' + args.channel
    end
  rescue Exception
    raise 'You must pass the channel name!'
  end
  
  return server, channel
end

namespace :irc do
  task :join, [:channel, :server] do |t, a|
    server, channel = parse_channel_and_server(a)
    
    Merb.logger.info "Joined #{channel} at #{server}"
  end
  
  task :leave, [:channel, :server] do |t, a|
    server, channel = parse_channel_and_server(a)
  
    Merb.logger.info "Left #{channel} at #{server}"
  end
  
  task :say, [:channel, :server, :message] do |t, a|
    server, channel = parse_channel_and_server(a)
  
    Merb.logger.info "Said '#{message}' in #{channel} at #{server}"
  end
  
  task :listen do
  
    Merb.logger.info "Listening for messages..."
  end
end
