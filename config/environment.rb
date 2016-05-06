# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Required for NTLM SMTP authentication type
require 'ntlm/smtp'

# Initialize the Rails application.
Rails.application.initialize!
