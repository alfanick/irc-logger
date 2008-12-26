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
	
		// If first link
		if (event.element().next()) {
			// Get first message id
			id = event.element().adjacent('ol li.message').first().id.split(/_/)[1];
			limit =  -messages.configuration.default_limit;
		} else { // If last link
			// Get last message id
			id = event.element().adjacent('ol li.message').last().id.split(/_/)[1];
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
				// If first link
				if (event.element().next())
					// Add messages to the top
					event.element().adjacent('ol').first().insert({ top: transport.responseText });
				else // If last link
					// Add messages to the bottom
					event.element().adjacent('ol').first().insert({ bottom: transport.responseText });
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