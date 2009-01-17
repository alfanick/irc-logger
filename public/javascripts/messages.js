/**
 * Messages
 */
var Messages = Class.create({
	/**
	 * Initialize when document loads
	 */
	initialize: function() {
		document.observe("dom:loaded", this.decorate.bindAsEventListener(this));
	},
	
	/**
	 * Decorate "Read more" links with AJAX
	 */
	decorate: function() {
		// Find links
		$$('#results.irc a.action').each(function(a) {
			// Observe click event
			a.observe("click", messages.read_more_clicked.bindAsEventListener(messages));
		});
	},
	
	/**
	 * "Read more" link on click event
	 */
	read_more_clicked: function(event) {
		// Prevent link execution
		Event.stop(event);
	
		el = event.element();
	
		// If first link
		if (el.next()) {
			// Get first message id
			id = el.adjacent('ol li.message').first().id.split(/_/)[1];
			limit =  -messages.configuration.default_limit;
		} else { // If last link
			// Get last message id
			id = el.adjacent('ol li.message').last().id.split(/_/)[1];
			limit =  messages.configuration.default_limit;
		}
		
		// Prepare url
		url = messages.configuration.read_more_url.evaluate({ 
				id: id, 
				limit: limit
		});
		
		// Make AJAX request
		new Ajax.Request(url, {
			method: 'get',
			// When done
			onSuccess: function(transport)
			{	
				response = transport.responseJSON;
				
				// If first link
				if (el.next())
					// Add messages to the top
					el.adjacent('ol').first().insert({ top: response.content });
				else // If last link
					// Add messages to the bottom
					el.adjacent('ol').first().insert({ bottom: response.content });
				// Update date
				el.previous('em.date').update(response.date);
			}
		});
	},
	
	// Configuration
	configuration: {
		// Read more route
		read_more_url: new Template('/messages/more/#{id}/#{limit}'),
		// Limit
		default_limit: 5
	}
});
// Start!
var messages = new Messages();
