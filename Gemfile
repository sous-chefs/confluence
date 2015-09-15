source 'https://rubygems.org'

gem 'rake'
gem 'stove'

group :test, :integration do
  gem 'berkshelf', '~> 3.0'
end

group :test do
  gem 'chefspec', '~> 4.0'
  gem 'foodcritic', '~> 4.0'
  gem 'rubocop', '~> 0.32'
end

group :integration do
  gem 'busser-serverspec', '~> 0.2.6'
  gem 'kitchen-digitalocean'
  gem 'kitchen-vagrant', '~> 0.18'
  gem 'test-kitchen', '~> 1.4'
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
