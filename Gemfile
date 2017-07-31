source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
ruby '2.3.0'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
# gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'semantic-ui-sass', git: 'https://github.com/doabit/semantic-ui-sass.git'
gem 'haml-rails'
gem 'high_voltage'
gem 'pg'
gem 'active_model_serializers', '~> 0.10.0'
gem 'dotenv-rails'
gem 'pg_search'
gem 'mail_form'
gem 'will_paginate', '~> 3.1.0'
gem "will_paginate_semantic_ui"
gem 'jquery-easing-rails'

group :development do
  gem 'better_errors'
  gem 'guard-bundler'
  gem 'guard-rails'
  gem 'guard-rspec'
  gem 'guard-livereload', '~> 2.5', require: false
  gem 'html2haml'
  # gem 'hub', :require=>nil
  gem 'rails_apps_pages'
  gem 'rails_apps_testing'
  gem 'rails_layout'
  gem 'rb-fchange', :require=>false
  gem 'rb-fsevent', :require=>false
  gem 'rb-inotify', :require=>false
  gem 'spring-commands-rspec'

  gem 'pdf-reader'
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'faker'
  gem 'capybara'
  gem 'poltergeist'
  gem 'pry-rails'
  gem 'pry-coolline'
  gem 'pry-byebug'
end

group :test do
  gem 'database_cleaner'
  gem 'launchy'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'shoulda-callback-matchers', '~> 1.1.4'
end

