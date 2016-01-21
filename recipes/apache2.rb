#
# Cookbook Name:: confluence
# Recipe:: apache2
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

node.set['apache']['listen_ports'] = node['apache']['listen_ports'] + [node['confluence']['apache2']['port']] unless node['apache']['listen_ports'].include?(node['confluence']['apache2']['port'])
node.set['apache']['listen_ports'] = node['apache']['listen_ports'] + [node['confluence']['apache2']['ssl']['port']] unless node['apache']['listen_ports'].include?(node['confluence']['apache2']['ssl']['port'])

include_recipe 'apache2'
include_recipe 'apache2::mod_proxy'
include_recipe 'apache2::mod_proxy_http'
include_recipe 'apache2::mod_ssl'
include_recipe 'apache2::mod_alias'
include_recipe 'letsencrypt'

apache_conf 'letsencrypt'

directory '/etc/ssl/localcerts'

crt = "/etc/ssl/localcerts/#{confluence_virtual_host_name}.crt"
key = "/etc/ssl/localcerts/#{confluence_virtual_host_name}.key"

node.default['confluence']['apache2']['ssl']['certificate_file'] = crt
node.default['confluence']['apache2']['ssl']['key_file'] = key

letsencrypt_certificate confluence_virtual_host_name do
  crt      crt
  key      key
  method   'http'
  wwwroot  node['apache']['docroot_dir']
end

web_app confluence_virtual_host_alias do
  cookbook node['confluence']['apache2']['template_cookbook']
end
