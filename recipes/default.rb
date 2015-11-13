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

settings = merge_confluence_settings

include_recipe 'confluence::database' if settings['database']['host'] == '127.0.0.1'
include_recipe "confluence::linux_#{node['confluence']['install_type']}"
include_recipe 'confluence::configuration'
include_recipe 'confluence::tomcat_configuration'
include_recipe 'confluence::apache2'
include_recipe 'confluence::crowd_sso' if settings['crowd_sso']['enabled']
