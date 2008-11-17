namespace :irc do
  task :join, [:channel, :server] do |t, a|
    server = a.server || 'irc.freenode.net'
    if a.channel =~ /^#/
      channel = a.channel
    else
      channel = '#' + a.channel
    end
    
    Merb.logger.info "Adding channel #{channel} at server #{server}"
  end
end
