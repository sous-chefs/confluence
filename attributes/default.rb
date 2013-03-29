#
# Cookbook Name:: confluence
# Attributes:: confluence
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

default['confluence']['home_path']      = "/var/atlassian/application-data/confluence"
default['confluence']['install_path']   = "/opt/atlassian/confluence"
default['confluence']['install_type']   = "installer"
default['confluence']['url_base']       = "http://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence"
default['confluence']['user']           = "confluence"
default['confluence']['version']        = "5.1"

if node['kernel']['machine'] == "x86_64"
  default['confluence']['arch'] = "x64"
else
  default['confluence']['arch'] = "x32"
end

case node['platform_family']
when "windows"
  case node['confluence']['install_type']
  when "cluster-standalone"
    default['confluence']['url']      = "#{node['confluence']['url_base']}-#{node['confluence']['version']}-cluster.zip"
    default['confluence']['checksum'] = case node['confluence']['version']
    when "4.3.7"; "c9f9213a787d76151ef133d75247707300cb55e93c28961276b8c6c4f702b3bf"
    when "5.0.1"; "58cfd477deba06d2d3c87be37a69ac75b9f6b463f011b4586b4ab1b64d2dd3b2"
    when "5.1"; "8177fbb2c9804447b3dcc4157af1c0bb41070fdbe07091c2a7b893a4f3717388"
    end
  when "cluster-war"
    default['confluence']['url']      = "#{node['confluence']['url_base']}-#{node['confluence']['version']}-cluster-war.zip"
    default['confluence']['checksum'] = case node['confluence']['version']
    when "4.3.7"; "92176b0f398cc6b2c6fc9def18268bb82e85361ae297de1a4380d10d0b55c4a6"
    when "5.0.1"; "0abaadb03af9b3c5aeb784da7cc98f8e63123995cbd741b63d1a003059efd1f5"
    when "5.1"; "0665ee08310d1f4595b9985c3efbb3c1cbf1b6d6bcf7e62aec970584fd661fef"
    end
  when "installer"
    default['confluence']['url']      = "#{node['confluence']['url_base']}-#{node['confluence']['version']}-#{node['confluence']['arch']}.exe"
    default['confluence']['checksum'] = case node['confluence']['version']
    when "4.3.7"; node['confluence']['arch'] == "x64" ? "5cc58d87f82afae574f053135ee214719c5e46f689affc1bdb819f69c69ed216" : "5316a2a4b35efc0342fee27044ca65f3eff1103ac4f09fb3d11596941dd00b55"
    when "5.0.1"; node['confluence']['arch'] == "x64" ? "f2766ee08ffa5a5d6662f150848f4fbc6aba3bc785679f146a4c94dbfcb59f6b" : "31ebe313124b95dd37981cc9d4b76bae25a4029fa33ac0779bc89162f12a2aa3"
    when "5.1"; node['confluence']['arch'] == "x64" ? "51c0352709fafe435b3812d40c1962f8a8fe90d20521cab6aba75dcb30af6ff5" : "5ec353141e58ca653b061f292e0809d60dac98171e71e12292eb7a349f838066"
    end
  when "standalone"
    default['confluence']['url']      = "#{node['confluence']['url_base']}-#{node['confluence']['version']}.zip"
    default['confluence']['checksum'] = case node['confluence']['version']
    when "4.3.7"; "726053c9ed8f56100bb5b3eb0ca9430e1beab73c3e26488cda1d23a42dd52dd7"
    when "5.0.1"; "43e4e80de5d1f32c73fd5829855b5a10f6d114e91e62c32caced2212a57fc2c5"
    when "5.1"; "937c3d763cbd6282d56dfa32d4ce68ffec94bb53aa8e63e7e566fd858a6ee0f9"
    end
  when "war"
    default['confluence']['url']      = "#{node['confluence']['url_base']}-#{node['confluence']['version']}-war.zip"
    default['confluence']['checksum'] = case node['confluence']['version']
    when "4.3.7"; "f97cb7ca185a975769c787248784fb36d65645bc4ed70dbbac4a5b7c7ce4fc59"
    when "5.0.1"; "84130989e8dee53e6b651519667e533ac1d9676a2cac190b43f5a57222c31201"
    when "5.1"; "e74278cf01e979a98d04cb2e9c577385123fd17dccdfe83ce853213b13911bc2"
    end
  end
else
  case node['confluence']['install_type']
  when "cluster-standalone"
    default['confluence']['url']      = "#{node['confluence']['url_base']}-#{node['confluence']['version']}-cluster.tar.gz"
    default['confluence']['checksum'] = case node['confluence']['version']
    when "4.3.7"; "d3ca45a1358166c67bf332bceef68393195a2bf800b4ee4fea18159144dfb4eb"
    when "5.0.1"; "b126935655bbd697bba64e69e8bc6e11fc31d73722829469ebe1a833366cca90"
    when "5.1"; "d12b6284634348fc0abf3224094b051a39862034548472c1454308b85778aed3"
    end
  when "cluster-war"
    default['confluence']['url']      = "#{node['confluence']['url_base']}-#{node['confluence']['version']}-cluster-war.tar.gz"
    default['confluence']['checksum'] = case node['confluence']['version']
    when "4.3.7"; "b644b8a95edd3a79b9406c828852174133d6f18d3f853b724d3724e16d5615de"
    when "5.0.1"; "a4945a98117830d19965fd066632245cd713b96845d5f2a444de6eb923271174"
    when "5.1"; "64f35423d53cedafc825fd17ed1130bad02de35b14c99f59cf0eadb5f0f09a96"
    end
  when "installer"
    default['confluence']['url']      = "#{node['confluence']['url_base']}-#{node['confluence']['version']}-#{node['confluence']['arch']}.bin"
    default['confluence']['checksum'] = case node['confluence']['version']
    when "4.3.7"; node['confluence']['arch'] == "x64" ? "03bb665b6abdc96495fca3f12683083d5e4633152f0c5cb4464779dcdd869f71" : "6612ab99ae0cf3ab240f9d9413a25bfe84b3f729cbb12ee4bee4e11a424513d0"
    when "5.0.1"; node['confluence']['arch'] == "x64" ? "97f233a3d8f0cbedcdbdf10ce7a38cf72c091945a8281909e871828165b6ab8e" : "b856b67564dade5930cae9590fd29ae15326e99e4b548a69b9e336d7e9659881"
    when "5.1"; node['confluence']['arch'] == "x64" ? "ac2cd3842b625ff6d451cf699c3b67685628cea2fd71dfbbcddcabd74f6f25eb" : "8b6acd4e807964b2c9f3fc9ced0c464183ee8ec73ddc3c8015dadb799be53c4c"
    end
  when "standalone"
    default['confluence']['url']      = "#{node['confluence']['url_base']}-#{node['confluence']['version']}.tar.gz"
    default['confluence']['checksum'] = case node['confluence']['version']
    when "4.3.7"; "18602095e4119cc5498ac14b4b5588e55f707cca73b36345b95c9a9e4c25c34d"
    when "5.0.1"; "18a497bf0899835d304e9a33431f347a28312e219d4555302e6332a3145b8191"
    when "5.1"; "3e6eced828d196bb6f18becb524c0191d4561308d71d85178fef84d5a6386203"
    end
  when "war"
    default['confluence']['url']      = "#{node['confluence']['url_base']}-#{node['confluence']['version']}-war.tar.gz"
    default['confluence']['checksum'] = case node['confluence']['version']
    when "4.3.7"; "2f1b3a074f083dc4cd8f38505e4fc75cab1961a8880192512482983f56aaa0d7"
    when "5.0.1"; "77d616359e1f2f3c5c4314fdd8149d926dc68406b8b9d6dfc9e0b5ac98ee611f"
    when "5.1"; "77f82bceedced6f8d58012b550f8886350dd5556d3de5eb700399a37223d08f4"
    end
  end
end

default['confluence']['apache2']['access_log']         = ""
default['confluence']['apache2']['error_log']          = ""
default['confluence']['apache2']['port']               = 80
default['confluence']['apache2']['virtual_host_alias'] = node['fqdn']
default['confluence']['apache2']['virtual_host_name']  = node['hostname']

default['confluence']['apache2']['ssl']['access_log']       = ""
default['confluence']['apache2']['ssl']['chain_file']       = ""
default['confluence']['apache2']['ssl']['error_log']        = ""
default['confluence']['apache2']['ssl']['port']             = 443

case node['platform_family']
when 'rhel'
  default['confluence']['apache2']['ssl']['certificate_file'] = "/etc/pki/tls/certs/localhost.crt"
  default['confluence']['apache2']['ssl']['key_file']         = "/etc/pki/tls/private/localhost.key"
else
  default['confluence']['apache2']['ssl']['certificate_file'] = "/etc/ssl/certs/ssl-cert-snakeoil.pem"
  default['confluence']['apache2']['ssl']['key_file']         = "/etc/ssl/private/ssl-cert-snakeoil.key"
end

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
