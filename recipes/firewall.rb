#
# Cookbook Name:: confluence
# Recipe:: apache2
#
# Copyright 2017, Jens Grassel
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

include_recipe 'firewall::default'

ports =
  if node['confluence']['firewall']['ports'].nil? || node['confluence']['firewall']['ports'].empty?
    "#{node['confluence']['apache2']['port']},#{node['confluence']['apache2']['ssl']['port']},#{node['confluence']['tomcat']['port']}".split(',').map(&:to_i)
  else
    node['confluence']['firewall']['ports'].split(',').map(&:to_i)
  end

firewall_rule "open ports #{ports}" do
  port ports
  protocol :tcp
  command :allow
end
