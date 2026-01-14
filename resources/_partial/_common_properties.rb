#
# Cookbook:: confluence
# Resource:: Partial:: _common_properties
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

property :instance_name, String,
         name_property: true,
         description: 'Name of the Confluence instance'

property :install_path, String,
         default: lazy { default_install_path },
         description: 'Installation directory for Confluence'

property :home_path, String,
         default: lazy { default_home_path },
         description: 'Home directory for Confluence data'

property :user, String,
         default: lazy { default_confluence_user },
         description: 'System user to run Confluence'

property :group, String,
         default: lazy { default_confluence_group },
         description: 'System group for Confluence user'
