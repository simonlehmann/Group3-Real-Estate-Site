# IMPORTANT

## Don't merge this with master. It's for experiments only

### Setting up infinite scroll

Chat with @ulternate but here's a quick and dirty guide for getting it ready

* Need the following added to gemfile
```ruby
gem 'kaminari'
gem 'jquery-infinite-pages'
```
* In your view controller you need to pass your array of objects like this
```ruby
def action
  @tests = Test.order(:name).page params[:page]
end
```
* In your template you should have some way of displaying that data like follows
```html
<div class="infinite-table centered">
  <%= render partial: 'infinite_scroll_test/data_item', object: @tests %>
  <p class="pagination">
    <%= link_to_next_page(@tests, 'Next Page', remote: true) %>
  </p>
</div>
```
* You need a partial that will be pulled in for each array element like this
```erb
<% # The data item filled in the table %>
<% @tests.each do |test| %>
	<tr>
		<td><%= test.name %> (<%= test.id %>)</td>
		<td><%= link_to "Find me here", test.address %></td>
	</tr>
<% end %>
```
* You need a file named the same as your main layout like so 'main-layout.js.erb' and in the same directory. Place this in it
```erb
// This is to append new data to the table in main-layout (or whatever you call it, I called it infinite_scroll_test)

// Append new data
$("<%=j render(partial: 'infinite_scroll_test/data_item', object: @tests) %>").appendTo($(".infinite-table table"));

// Update pagination link
<% if @tests.last_page? %>
	$('.pagination').html("That's all, folks!");
<% else %>
	$('.pagination').html("<%=j link_to_next_page(@tests, 'Next Page', remote: true) %>");
<% end %>
```
* Have the following in your coffee file, I've got mine in the document ready function:
```coffee
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
* Configuration of the pagination is done by runing `rails g kaminari:config` and editing the config file now found in the `config/initializers` folder. I edited the default_per_page in mine
* Now, provided you have data in your database for your array object then you should be good to go

# DON'T PULL THIS INTO MASTER OR YOUR OWN BRANCH
## It's probably going to cause issues and it's not too hard for me/you to set up closer to delivery.
