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

directory File.dirname(node['confluence']['home_path']) do
  owner 'root'
  group 'root'
  mode 00755
  action :create
  recursive true
end

user node['confluence']['user'] do
  comment 'Confluence Service Account'
  home node['confluence']['home_path']
  shell '/bin/bash'
  supports :manage_home => true
  system true
  action :create
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

remote_file "#{Chef::Config[:file_cache_path]}/atlassian-confluence-#{node['confluence']['version']}.tar.gz" do
  source node['confluence']['url']
  checksum node['confluence']['checksum']
  mode '0644'
  action :create_if_missing
end

directory File.dirname(node['confluence']['install_path']) do
  owner node['confluence']['user']
  group node['confluence']['user']
  mode 00755
  action :create
  recursive true
end

execute "Extracting Confluence #{node['confluence']['version']}" do
  cwd Chef::Config[:file_cache_path]
  command <<-COMMAND
    tar -zxf atlassian-confluence-#{node['confluence']['version']}.tar.gz
    mv atlassian-confluence-#{node['confluence']['version']} #{node['confluence']['install_path']}
    chown -R #{node['confluence']['user']} #{node['confluence']['install_path']}
  COMMAND
  creates "#{node['confluence']['install_path']}/confluence"
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
