source 'https://rubygems.org'

gem 'rake'

group :test, :integration do
  gem 'berkshelf', '~> 4.0'
end

group :test do
  gem 'chefspec', '~> 4.0'
  gem 'foodcritic', '~> 4.0'
  gem 'rubocop', '~> 0.32'
end

group :integration do
  gem 'busser-serverspec', '~> 0.2.6'
  gem 'kitchen-digitalocean'
  gem 'kitchen-sync'
  gem 'kitchen-vagrant', '~> 0.18'
  gem 'test-kitchen', '~> 1.4'
end
