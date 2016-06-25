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
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 } # <- Change host to site's production domain name and port to 80 for deployment e.g { host: 'propertydome.com', port: 80 }

  # Programatically configure Paperclip to hopefully work on OS X and Windows
  # This is done by checking for the windows directory for the FILE binary folder
  # installed when Paperclip and ImageMagick are set up. If the folder exists, then use Windows.
  # Otherwise, use OS X config variables
  if File.directory?('C:\Program Files (x86)\GnuWin32\bin')
    puts "------------- Using Window's config for Paperclip Gem -------------"
    Paperclip.options[:command_path] = 'C:\Program Files (x86)\GnuWin32\bin'
    puts "------------- Paperclip configured using 'C:\\Program Files (x86)\\GnuWin32\\bin' -------------"
  else
    puts "------------- Using OS X's config for Paperclip Gem -------------"
    Paperclip.options[:image_magick_path] = "/opt/ImageMagick/bin"
    Paperclip.options[:command_path] = "/opt/ImageMagick/bin"
    puts "------------- Paperclip configured using '/opt/ImageMagick/bin' -------------"
  end

  # For mail delivery debugging
  config.action_mailer.raise_delivery_errors = true

  # Set mail server connection protocal
  config.action_mailer.delivery_method = :smtp

  # Define mail server connection parameters
  config.action_mailer.smtp_settings = {
    address: ENV["TEST_SMTP_HOST"],
    port: 587,
    domain: "slehmann36.com",
    authentication: "ntlm", # <- Change this to required authentication type for deployment!
    enable_starttls_auto: false, # <- Change this back to true for deployment!
    user_name: ENV["TEST_SMTP_USER"], # ENV[“GMAIL_USERNAME”]
    password: ENV["TEST_SMTP_PASS"]
  }

end
