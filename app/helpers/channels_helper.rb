module Merb
  module ChannelsHelper

		def font_size(channel)
      Merb::Cache[:default].fetch(channel.id.to_s + "_ch_fonts", :interval => Time.now.to_i / Merb::Config[:cache]["intervals"]["font_size"]) do
        x = (150 * (1 + (1.5*channel.messages_count.to_i - 300/2)/300))
        
        x = 400 if x > 400
        
        "font-size: %i%%;" % x
      end
    end
  end
end # Merb