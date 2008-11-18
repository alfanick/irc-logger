def parse_channel_and_server(url)
  args = url.split('/')

  if args.size == 2 
    server = args[0]
    channel = args[1]
  else
    server = Merb::Config[:irc_default_server]
    channel = args[0]
  end
  
  channel = '#' + channel if not channel =~ /^#/
  
  return server, channel
end

namespace :irc do
  task :join, [:url] do |t, a|
    server, channel = parse_channel_and_server(a.url)
    
    Merb.logger.info "Joined #{channel} at #{server}"
  end
  
  task :leave, [:url] do |t, a|
    server, channel = parse_channel_and_server(a.url)
  
    Merb.logger.info "Left #{channel} at #{server}"
  end
  
  task :list, [:url] do |t, a|
  
  end
  
  task :say, [:url, :message] do |t, a|
    server, channel = parse_channel_and_server(a.url)
  
    Merb.logger.info "Said '#{message}' in #{channel} at #{server}"
  end
  
  task :listen do
  
    Merb.logger.info "Listening for messages..."
  end
end
