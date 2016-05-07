Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  config.action_view.raise_on_missing_translations = true

  # Default Devise mailer settings
<<<<<<< HEAD
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 } # <- Change 'localhost' to the sites production domain name and port to 80 for deployment e.g { host: 'propertydome.com', port: 80 }
=======
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 } # <- Change host to site's production domain name and port to 80 for deployment e.g { host: 'propertydome.com', port: 80 }
>>>>>>> 1a09fe99ca7917f96b74990f5f228c6f0b00740d

  # Paperclip config for mac osx image_magick_path:
  Paperclip.options[:image_magick_path] = "/opt/ImageMagick/bin"
  Paperclip.options[:command_path] = "/opt/ImageMagick/bin"

  # For mail delivery debugging
  config.action_mailer.raise_delivery_errors = true

  # Set mail server connection protocal
  config.action_mailer.delivery_method = :smtp

  # Define mail server connection parameters
  config.action_mailer.smtp_settings = {
    address: "mail.slehmann36.com",
    port: 587,
    domain: "slehmann36.com",
    authentication: "ntlm", # <- Change this to required authentication type for deployment!
    enable_starttls_auto: false, # <- Change this back to true for deployment!
    user_name: "PropertyDome@slehmann36.com", # ENV[“GMAIL_USERNAME”]
    password: "sJ2PVZ2cbvYqMMN" # ENV[“GMAIL_PASSWORD”]
  }

end
