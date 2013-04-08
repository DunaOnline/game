source 'http://rubygems.org'

gem 'rails', '3.2.13'
gem 'rake', '=0.9.2.2'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'
#gem 'sqlite3-ruby', '1.2.5', :require => 'sqlite3'
#gem 'mysql'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'#,   '~> 3.1.4'
  gem 'coffee-rails'#, '~> 3.1.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', :require => "bcrypt"

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19'#, :require => 'ruby-debug'
# gem 'ruby-debug-ide19'

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end

group :test, :development do
  gem "rspec-rails", "~> 2.0"
  gem 'factory_girl_rails'
end

gem 'cancan'
#gem 'vestal_versions', :git => 'git://github.com/adamcooper/vestal_versions', :branch => 'rails3'
gem 'kaminari'#, '0.10.4'
#gem "calendar_date_select", :git => 'http://github.com/paneq/calendar_date_select.git', :branch => 'rails3test'
gem 'decent_exposure'

group :development do
  gem 'nifty-generators'
  gem 'annotate', :git => 'git://github.com/ctran/annotate_models.git'
end

gem 'whenever', :require => false

gem 'best_in_place'

gem 'active_record_or'
gem 'randumb'
group :development do
  gem 'meta_request', '0.2.0'
end