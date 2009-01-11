require 'rubygems'
require 'starling'
require 'the_logger/bot'
require 'the_logger/supervisor'

# Logging machine
module TheLogger
  # Listener (on the worker side)
  class Listener
    # Initialize Listener
    #
    # Params
    # - +server+ - String - server and port to starling
    # - +name+ - String - listener name (must be unique!)
    # - +options+ - Hash - options (login credentials)
    def initialize(server, name, options)
      @server = name
      @name = name
      @options = options
      
      @threads = []
			@channels = []
      
      # Create Starling client
      @starling = Starling.new(server)
    end
    
    # Start listening for queue
    def run
      # Get messages from queue
      loop do
        result = @starling.get(@name)
        
        # If exit request
        if result == :exit
          # Exit from each server
          @threads.each { |t| t[:bot].irc.quit; t.exit }
          break
				else
					# If ping request
					if result == :ping
						# Send channels
						@starling.set(PING_QUEUE, @channels.uniq)
					# If channel
					else
						found = false

						# Added channel
						@channels.push result

						# Look for server
						@threads.each do |t|
							if t[:server] == result[:server]
								# Join the channel
								t[:bot].join result[:channel]
								found = true
								break
							end
						end

						# If new server
						if not found
							# Create thread
							@threads.push (Thread.new(@name, result, @options) do |n, r, o|
								Thread.current[:server] = r[:server]
								# Create Bot
								Thread.current[:bot] = Bot.new(r[:server], n, o)
								# Start listening
								Thread.current[:bot].irc_loop
							end)

							# Wait for server
							sleep 30

							# Join the channel
							@threads.last[:bot].join(result[:channel])
						end
					end
				end
      end
    end
  end
end
