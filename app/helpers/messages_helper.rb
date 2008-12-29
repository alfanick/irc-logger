module Merb
  module MessagesHelper
    # Format Message to HTML
    def format_message (message)  
      Merb::Cache[:default].fetch(message.id.to_s + "_format", :interval => Time.now.to_i / Merb::Config[:cache]["intervals"]["format_message"]) do
        if message.event == :message
          # HTML encode
          c = h("<#{message.guy.nickname}> #{message.content}")
          # Create links
          c.sub! /((http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/[^\n ]*)?)/ix, '<a class="external" href="\1">\1</a>'
          # Strong
          c.sub! /\*(.+?)\*/, '<strong>\1</strong>'
          # Emphasis
          c.sub! /_(.+?)_/, '<em>\1</em>'
          # Create link to username
          c.sub! message.guy.nickname, link_to(message.guy.nickname, url(:show_guy, :nickname => message.guy.nickname))
          if m = c.match("&gt; ([^ ]+)(:|,)")
            if g = Guy.get(m[1]) or g = Guy.get(m[1].downcase)
              c.sub! m[1], link_to(m[1], url(:show_guy, :nickname => g.nickname))
            end
          end
          '<code class="irc message">' + c + '</code>'
        else
          c = h("*** #{message.content}")
          # Create link to username
          c.sub! message.guy.nickname, link_to(message.guy.nickname, url(:show_guy, :nickname => message.guy.nickname))
          '<code class="irc notice">' + c + '</code>'
        end
      end
    end
    
    def raw_message(message)
      time = message.created_at.strftime "[%H:%M]"
      if message.event == :message
        "#{time} <#{message.guy.nickname}> #{message.content}\n"
      else
        "#{time} *** #{message.content}\n"
      end
    end
    
    def read_more (message, down=true)
      b = 10
      c = 20
      
      b = params['bcount'].to_i if params['bcount']
      c = params['count'].to_i if params['count']
    
      if down
        c = params['count'].to_i + 20
      else
        b = params['bcount'].to_i + 10
      end

      link_to("Read more", url(:show_message, :id => message.id, :count => c, :bcount => b), :class => 'action')
    end
  end
end # Merb
