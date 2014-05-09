# Load the rails application
require File.expand_path('../application', __FILE__)

# Added by Rohan - Load app configs
APP_CONFIG = YAML::load(File.open("#{Rails.root}/config/appconfig.yml"))[Rails.env]

# Added by Rohan - set smtp host configuration
#SMTP_SETTINGS = {
#  address:                 "smtp.bizmail.yahoo.com",
#  port:                    465,
#  domain:                  'kiprosh.com',
#  authentication:          'plain',
#  user_name:               'careers@kiprosh.com',
#  password:                'careers0987',
#  enable_starttls_auto:    true }

SMTP_SETTINGS = {
  address:              'smtp.sendgrid.net',
  port:                  587,
  domain:               'knowbuddy.kiprosh-app.com',
  user_name:            'shivanibhanwal',
  password:             'send#grid#1928',
  authentication:       'plain',
  enable_starttls_auto:  true  }

# Initialize the rails application
KYU::Application.initialize!

