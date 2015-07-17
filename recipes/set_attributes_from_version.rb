#
# Cookbook Name:: confluence
# Library:: set_attributes_from_version
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

# Calculate variables that depend on ['confluence']['version'] attribute.
# If you need to override this in an attribute file you should use
# 'force_default' or higher precedence.

node.default['confluence']['url'] = get_artifact_url(
  node['confluence']['version'],
  node['confluence']['install_type'],
  node['confluence']['arch']
)

node.default['confluence']['checksum'] = get_artifact_checksum(
  node['confluence']['version'],
  node['confluence']['install_type'],
  node['confluence']['arch']
)
