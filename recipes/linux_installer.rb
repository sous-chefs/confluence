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

# Install or upgrade confluence
if confluence_version != node['confluence']['version']
  template "#{Chef::Config[:file_cache_path]}/atlassian-confluence-response.varfile" do
    source 'response.varfile.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      'update' => Dir.exist?(node['confluence']['install_path'])
    )
  end

  Chef::Resource::RemoteFile.send(:include, Confluence::Helpers)

  remote_file "#{Chef::Config[:file_cache_path]}/atlassian-confluence-#{node['confluence']['version']}.bin" do
    source confluence_artifact_url
    checksum confluence_artifact_checksum
    mode '0755'
    action :create
  end

  execute "Installing Confluence #{node['confluence']['version']}" do
    cwd Chef::Config[:file_cache_path]
    command "./atlassian-confluence-#{node['confluence']['version']}.bin -q -varfile atlassian-confluence-response.varfile"
  end
end
