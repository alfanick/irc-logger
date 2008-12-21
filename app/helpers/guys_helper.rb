module Merb
  module GuysHelper
    include MessagesHelper
    
    def font_size(guy)
      Merb::Cache[:default].fetch(guy.id.to_s + "_fonts", :interval => Time.now.to_i / Merb::Config[:cache]["intervals"]["font_size"]) do
        x = (150 * (1 + (1.5*guy.messages_count.to_i - 300/2)/300))
        
        x = 400 if x > 400
        
        "font-size: %i%%;" % x
      end
    end
  end
end # Merb
