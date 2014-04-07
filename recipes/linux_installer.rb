#
# Cookbook Name:: confluence
# Recipe:: linux_installer
#
# Copyright 2013, Brian Flad
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

settings = Confluence.settings(node)

template "#{Chef::Config[:file_cache_path]}/atlassian-confluence-response.varfile" do
  source 'response.varfile.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

remote_file "#{Chef::Config[:file_cache_path]}/atlassian-confluence-#{node['confluence']['version']}-#{node['confluence']['arch']}.bin" do
  source node['confluence']['url']
  checksum node['confluence']['checksum']
  mode '0755'
  action :create_if_missing
end

execute "Installing Confluence #{node['confluence']['version']}" do
  cwd Chef::Config[:file_cache_path]
  command "./atlassian-confluence-#{node['confluence']['version']}-#{node['confluence']['arch']}.bin -q -varfile atlassian-confluence-response.varfile"
  creates node['confluence']['install_path']
end

execute 'Generating Self-Signed Java Keystore' do
  command <<-COMMAND
    #{node['java']['java_home']}/bin/keytool -genkey \
      -alias #{settings['tomcat']['keyAlias']} \
      -keyalg RSA \
      -dname 'CN=#{node['fqdn']}, OU=Example, O=Example, L=Example, ST=Example, C=US' \
      -keypass #{settings['tomcat']['keystorePass']} \
      -storepass #{settings['tomcat']['keystorePass']} \
      -keystore #{settings['tomcat']['keystoreFile']}
    chown #{node['confluence']['user']}:#{node['confluence']['user']} #{settings['tomcat']['keystoreFile']}
  COMMAND
  creates settings['tomcat']['keystoreFile']
  only_if { settings['tomcat']['keystoreFile'] == "#{node['confluence']['home_path']}/.keystore" }
end

if settings['database']['type'] == 'mysql'
  include_recipe 'mysql_connector'
  mysql_connector_j "#{node['confluence']['install_path']}/lib"
end

template '/etc/init.d/confluence' do
  source 'confluence.init.erb'
  mode '0755'
  notifies :restart, 'service[confluence]', :delayed
end

service 'confluence' do
  supports :status => true, :restart => true
  action :enable
  subscribes :restart, 'java_ark[jdk]'
end
