# Load the rails application
require File.expand_path('../application', __FILE__)

# Added by Rohan - Load app configs
APP_CONFIG = YAML::load(File.open("#{Rails.root}/config/appconfig.yml"))[Rails.env]

# Added by Rohan - set smtp host configuration
SMTP_SETTINGS = {
  :address              => "mail.oncocure.com",
  :port                 => 25,
  :domain               => 'mail.oncocure.com',
  :user_name            => 'postmaster@oncocure.com',
  :password             => 'oncomail1234',
  :authentication       => 'plain',
  :enable_starttls_auto => true  }

# Initialize the rails application
KYU::Application.initialize!


