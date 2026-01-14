require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.file_cache_path = '/var/cache/chef'
  config.log_level = :error
  config.platform = 'ubuntu'
  config.version = '24.04'
end
