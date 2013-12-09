# Helpers module
module Helpers
  # Helpers::Confluence module
  module Confluence
    include MiniTest::Chef::Assertions
    include MiniTest::Chef::Context
    include MiniTest::Chef::Resources

    def apache_service
      service(case node['platform']
              when 'debian', 'ubuntu' then 'apache2'
              when 'freebsd' then 'apache22'
              else 'httpd'
              end)
    end
  end
end
