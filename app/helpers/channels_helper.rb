module Merb
  module ChannelsHelper
		include MessagesHelper

		def font_size(channel)
      Merb::Cache[:default].fetch(channel.id.to_s + "_ch_fonts", :interval => Time.now.to_i / Merb::Config[:cache]["intervals"]["font_size"]) do
        mx = Channel.max(:messages_count)

				x = (150 * (1 + (1.5*channel.messages_count.to_i - mx/2)/mx))
        
        x = 400 if x > 400
        
        "font-size: %i%%;" % x
      end
    end
  end
end # Merb