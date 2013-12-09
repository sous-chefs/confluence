#
# Cookbook Name:: confluence
# Recipe:: default
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

platform = 'windows' if node['platform_family'] == 'windows'
platform ||= 'linux'
settings = Confluence.settings(node)

include_recipe 'confluence::database' if settings['database']['host'] == 'localhost'
include_recipe "confluence::#{platform}_#{node['confluence']['install_type']}"

unless node['confluence']['install_type'].match('war')
  include_recipe 'confluence::tomcat_configuration'
  include_recipe 'confluence::apache2'
end

include_recipe 'confluence::configuration'
