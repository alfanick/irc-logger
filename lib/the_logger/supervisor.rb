require 'rubygems'
require 'starling'

# Logging machine
module TheLogger
  # Supervisor (task planner)
  class Supervisor
    # Create supervisor
    #
    # Params:
    # - +server+ - String - Starling server and port
    # - +listeners+ - Array - Listeners names
    def initialize(server, listeners)
      @server = server
      @listeners = listeners
      @last_listener = nil
      @channels = []
      
      @starling = Starling.new(@server)
    end
    
    # Start task planning
    def start
      loop do
        Server.all(:status => :enabled).each do |server|
          server.channels.all(:status => :enabled).each do |channel|
            next if @channels.include? channel
            
            @starling.set(next_listener, { :server => server.host, :channel => channel.name })
            
            @channels.push channel
          end
        end
        
        sleep 300
      end
    end
    
    # Stop listening
    def stop
      @listeners.each do |listener|
        @starling.set(listener, :exit)
      end
    end
    
    private
      def next_listener
        @last_listener = @listeners.at(@listeners.index(@last_listener).to_i + 1) or @listeners.first
      end
  end
end
