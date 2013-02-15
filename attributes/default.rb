#
# Cookbook Name:: confluence
# Attributes:: confluence
#
# Copyright 2012-2013
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

default['confluence']['version']        = "4.3.7"
default['confluence']['arch']           = "x64"
default['confluence']['url']            = "http://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-#{node['confluence']['version']}-#{node['confluence']['arch']}.bin"
default['confluence']['checksum']       = "03bb665b6abdc96495fca3f12683083d5e4633152f0c5cb4464779dcdd869f71"
default['confluence']['install_path']   = "/opt/atlassian/confluence"
default['confluence']['home_path']      = "/var/atlassian/application-data/confluence"
default['confluence']['user']           = "confluence"

default['confluence']['database']['host']     = "localhost"
default['confluence']['database']['name']     = "confluence"
default['confluence']['database']['password'] = "changeit"
default['confluence']['database']['port']     = 3306
default['confluence']['database']['type']     = "mysql"
default['confluence']['database']['user']     = "confluence"

default['confluence']['jvm']['minimum_memory']  = "256m"
default['confluence']['jvm']['maximum_memory']  = "512m"
default['confluence']['jvm']['maximum_permgen'] = "256m"
default['confluence']['jvm']['java_opts']       = ""

default['confluence']['tomcat']['keyAlias']     = "tomcat"
default['confluence']['tomcat']['keystoreFile'] = "#{node['confluence']['home_path']}/.keystore"
default['confluence']['tomcat']['keystorePass'] = "changeit"
default['confluence']['tomcat']['port']         = "8090"
default['confluence']['tomcat']['ssl_port']     = "8443"
