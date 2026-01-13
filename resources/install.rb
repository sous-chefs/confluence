#
# Cookbook:: confluence
# Resource:: install
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

unified_mode true

provides :confluence_install

use '_partial/_common_properties'

property :version, String,
         required: true,
         description: 'Version of Confluence to install'

property :url, String,
         default: lazy { confluence_download_url(version, 'standalone') },
         description: 'URL to download Confluence from. Defaults to Atlassian download URL'

property :checksum, String,
         description: 'SHA256 checksum of the download artifact'

action :install do
  # Create group
  group new_resource.group do
    system true
    action :create
  end

  # Create user
  user new_resource.user do
    comment 'Confluence Service Account'
    home new_resource.home_path
    shell '/bin/bash'
    gid new_resource.group
    manage_home false
    system true
    action :create
  end

  # Create home directory
  directory ::File.dirname(new_resource.home_path) do
    owner 'root'
    group 'root'
    mode '0755'
    recursive true
    action :create
  end

  directory new_resource.home_path do
    owner new_resource.user
    group new_resource.group
    mode '0750'
    recursive true
    action :create
  end

  # Create install directory parent
  directory ::File.dirname(new_resource.install_path) do
    owner 'root'
    group 'root'
    mode '0755'
    recursive true
    action :create
  end

  # Download and extract Confluence using ark
  ark 'confluence' do
    url new_resource.url
    checksum new_resource.checksum if new_resource.checksum
    prefix_root ::File.dirname(new_resource.install_path)
    home_dir new_resource.install_path
    version new_resource.version
    owner 'root'
    group 'root'
  end

  # Set ownership on runtime directories
  %w(logs temp work).each do |dir|
    directory ::File.join(new_resource.install_path, dir) do
      owner new_resource.user
      group new_resource.group
      mode '0750'
      action :create
    end
  end
end

action :remove do
  directory new_resource.install_path do
    recursive true
    action :delete
  end
end

action_class do
  include Confluence::Cookbook::Helpers
end
