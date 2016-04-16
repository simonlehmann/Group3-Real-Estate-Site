### Setting up infinite scroll

Chat with @ulternate but here's a quick and dirty guide for getting it ready

* ~~Need the following added to gemfile~~ <- Done in Master, run `bundle install` to install them. I've also added the correct information to the application.js file that's required to load the infinite-pages across all pages.
```ruby
gem 'kaminari'
gem 'jquery-infinite-pages'
```

* In this example I'm using a controller called `test_page` that you could generate using `rails g controller test_page action`

* In your view controller you need to get and pass your object that you wish to paginate like this
```ruby
/app/controllers/test_page_controller.rb

class TestPageController < ApplicationController
  def action
    @tests = Test.order(:name).page params[:page]
  end
end
```

* In your action's template you should have some way of displaying that data like follows
```html
/app/views/test_page/action.html.erb

<div class="infinite-table centered">
  <%= render partial: 'test_page/data_item', object: @tests %>
  <p class="pagination">
    <%= link_to_next_page(@tests, 'Next Page', remote: true) %>
  </p>
</div>
```

* You need a partial that will be pulled in for each array element like this
```erb
/app/views/test_page/_data_item.html.erb

<% # The data item filled in the table %>
<% @tests.each do |test| %>
	<tr>
		<td><%= test.name %> (<%= test.id %>)</td>
		<td><%= link_to "Find me here", test.address %></td>
	</tr>
<% end %>
```

* You need a file named the same as your main layout like so 'action.js.erb' and in the same directory. Place this in it
```erb
/app/views/test_page/action.js.erb

// This is to append new data to the table in main-layout (or whatever you call it, I called it infinite_scroll_test)

// Append new data
$("<%=j render(partial: 'test_page/data_item', object: @tests) %>").appendTo($(".infinite-table table"));

// Update pagination link
<% if @tests.last_page? %>
	$('.pagination').html("That's all, folks!");
<% else %>
	$('.pagination').html("<%=j link_to_next_page(@tests, 'Next Page', remote: true) %>");
<% end %>
```

* Have the following in your coffee file, I've got mine in the document ready function:
```coffee
/app/assets/javascripts/test_page.coffee

# Trigger a new page load
tester = ->
	$('.infinite-table').infinitePages
		buffer: 100 # Auto scroll when 100px from bottom of window
		loading: ->
			$(this).text 'Loading next page...'
		error: ->
			$(this).button 'There was an error, please try again'
	return

$(document).ready tester
$(document).on 'page:change', tester
```

* Global Configuration of the pagination is done by runing `rails g kaminari:config` and editing the config file now found in the `config/initializers` folder.
* If you want to configure the model directly then (considering we have a model called Test in this example) do the following in the model file:

```ruby
/app/models/test.rb

class Test < ActiveRecord::Base
	# Set the maximum listings to be shown initially (i.e. listings per page)
	paginates_per 5
end


* Now, provided you have data in your database for your model object then you should be good to go
