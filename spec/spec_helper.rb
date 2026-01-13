require 'chefspec'

# Stub deprecated Chef::Platform.set before loading cookbooks
class Chef
  class Platform
    def self.set(*args)
      # no-op stub for deprecated API
    end
  end
end

require 'chefspec/berkshelf'
require 'support/linux_installer'

RSpec.configure do |config|
  config.file_cache_path = '/var/cache/chef'
  config.log_level = :error
  config.platform = 'ubuntu'
  config.version = '20.04'
end
