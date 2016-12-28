require 'chefspec'
require 'chefspec/berkshelf'
require 'support/linux_installer'

RSpec.configure do |config|
  config.file_cache_path = '/var/cache/chef'
  config.log_level = :error
  config.platform = 'ubuntu'
  config.version = '16.04'
end
