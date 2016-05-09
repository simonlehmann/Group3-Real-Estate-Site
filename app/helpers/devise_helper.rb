#   Creator: Daniel Swain
#   Date created: 22/04/2016
#   
#   This helper is used to override the devise error messages styling.
#   
#   It's all stock, except for the message display html.

module DeviseHelper
	def devise_error_messages!
		return "" unless devise_error_messages?

		# Changed message content_tag to match semantic ui list style
		messages = resource.errors.full_messages.map { |msg| content_tag(:div, msg, class: "item") }.join
		sentence = I18n.t("errors.messages.not_saved",
						:count => resource.errors.count,
						:resource => resource.class.model_name.human.downcase)

		# Changed the html display code to match semantic ui list style
		html = <<-HTML
			<div id="error_explanation" class="ui error message">
				<h2 class="header">#{sentence}</h2>
				<div class="ui list">
					#{messages}
				</div>
			</div>
		HTML

		# If there's error messages this will be returned
		html.html_safe
	end

	def devise_error_messages?
		!resource.errors.empty?
	end

end
