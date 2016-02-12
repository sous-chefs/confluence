#
# Cookbook Name:: confluence
# Recipe:: linux_standalone
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
  supports manage_home: true
  system true
  action :create
end

Chef::Resource::Ark.send(:include, Confluence::Helpers)

ark 'confluence' do
  url confluence_artifact_url
  prefix_root File.dirname(node['confluence']['install_path'])
  home_dir node['confluence']['install_path']
  checksum confluence_artifact_checksum
  version node['confluence']['version']
  owner 'root'
  group 'root'
  notifies :restart, 'service[confluence]'
end

%w(logs temp work).each do |dir|
  directory File.join(node['confluence']['install_path'], dir) do
    owner node['confluence']['user']
    group 'root'
    mode 00700
    action :create
  end
end
