module Merb
  module MessagesHelper
    def format_message (message)
      if message.event == :message
        # HTML encode
        c = h("<#{message.guy.nickname}> #{message.content}")
        # Create links
        c.sub! /((http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/[^\n ]*)?)/ix, '<a class="external" href="\1">\1</a>'
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
  
    def talk_with (message, n=5)
      str = '<div class="irc talk">'
      str << "<h2>#{message.channel.name}</h2> <em class=\"server\">#{message.channel.server.name}</em> "
      ms = message.with_surroundings(n, false)
      str << "<em class=\"date\">#{ms.first.created_at}</em>"
      str << '<ol>'
      ms.each do |msg|
        c = msg.class.name
        cid = c + "_#{msg.id}"
        if msg == message
          str << "<li class=\"result #{c}\" id=\"#{cid}\"><strong>" << format_message(msg) << '</strong></li>'
        else
          str << "<li class=\"#{c}\" id=\"#{cid}\">" << format_message(msg) << "</li>"
        end
      end
      str << '</ol>'
      str << "<em class=\"date\">#{ms.last.created_at}</em><br/>"
      str << read_more(message)
      str << '</div>'
      
      str
    end
    
    def read_more (message)
      if params.include? 'count'
        c = params['count'].to_i + 20
      else
        c = 20
      end
    
      link_to("Read more", url(:show_message, :id => message.id, :count => c), :class => 'action')
    end
  end
end # Merb
