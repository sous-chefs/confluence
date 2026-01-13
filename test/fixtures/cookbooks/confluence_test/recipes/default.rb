#
# Cookbook:: confluence_test
# Recipe:: default
#
# Basic test recipe demonstrating confluence custom resources
#

apt_update 'update' if platform_family?('debian')

package 'tar'

# Install Confluence
confluence_install 'confluence' do
  version '10.2.2'
  install_path '/opt/atlassian/confluence'
  home_path '/var/atlassian/application-data/confluence'
  user 'confluence'
  group 'confluence'
end

# Configure Confluence
confluence_config 'confluence' do
  install_path '/opt/atlassian/confluence'
  home_path '/var/atlassian/application-data/confluence'
  user 'confluence'
  group 'confluence'
  jvm_minimum_memory '512m'
  jvm_maximum_memory '2g'
  tomcat_port '8090'
end

# Create and enable the service
confluence_service 'confluence' do
  install_path '/opt/atlassian/confluence'
  home_path '/var/atlassian/application-data/confluence'
  user 'confluence'
  group 'confluence'
  action [:create, :enable]
end
