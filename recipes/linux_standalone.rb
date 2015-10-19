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

settings = merge_confluence_settings

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

Chef::Resource::Ark.send(:include, Confluence::Helpers)

ark 'confluence' do
  url confluence_artifact_url
  prefix_root File.dirname(node['confluence']['install_path'])
  home_dir node['confluence']['install_path']
  checksum confluence_artifact_checksum
  version node['confluence']['version']
  owner node['confluence']['user']
  group node['confluence']['user']
end
