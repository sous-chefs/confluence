source 'https://rubygems.org'

gem 'rake'

group :test, :integration do
  gem 'berkshelf', '~> 3.2.2'
end

group :test do
  gem 'chefspec', '~> 4.0.1'
  gem 'cucumber'
  gem 'foodcritic', '~> 4.0.0'
  gem 'rubocop', '~> 0.28.0'
end

group :integration do
  gem 'busser-serverspec', '~> 0.2.6'
  gem 'busser-cucumber'
  gem 'kitchen-vagrant', '~> 0.14'
  gem 'kitchen-ec2'
  gem 'test-kitchen', '~> 1.1'
end

# group :development do
#   gem 'guard',         '~> 2.0'
#   gem 'guard-kitchen'
#   gem 'guard-rubocop', '~> 1.0'
#   gem 'guard-rspec',   '~> 3.0'
#   gem 'rb-inotify',    :require => false
#   gem 'rb-fsevent',    :require => false
#   gem 'rb-fchange',    :require => false
# end
