#
# Cookbook:: confluence_test
# Recipe:: standalone
#
# Test recipe demonstrating standalone Confluence installation with reverse proxy config
#

apt_update 'update' if platform_family?('debian')

# Install Confluence standalone
confluence_install 'confluence' do
  version '8.5.4'
end

# Configure for reverse proxy (nginx/apache in front)
confluence_config 'confluence' do
  jvm_minimum_memory '1g'
  jvm_maximum_memory '4g'
  tomcat_port '8090'
  tomcat_proxy_name 'confluence.example.com'
  tomcat_proxy_port '443'
  tomcat_scheme 'https'
  tomcat_secure true
end

# Create and enable the service (don't start - requires full Java environment)
confluence_service 'confluence' do
  action [:create, :enable]
end
