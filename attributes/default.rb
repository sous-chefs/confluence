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

default['confluence']['home_path']      = '/var/atlassian/application-data/confluence'
default['confluence']['install_path']   = '/opt/atlassian/confluence'
default['confluence']['install_type']   = 'installer'
default['confluence']['url_base']       = 'http://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence'
default['confluence']['user']           = 'confluence'
default['confluence']['version']        = '5.7'

if node['kernel']['machine'] == 'x86_64'
  default['confluence']['arch'] = 'x64'
else
  default['confluence']['arch'] = 'x32'
end

# rubocop:disable BlockNesting

case node['confluence']['install_type']
when 'installer'
  default['confluence']['url']      = "#{node['confluence']['url_base']}-#{node['confluence']['version']}-#{node['confluence']['arch']}.bin"
  default['confluence']['checksum'] =
    case node['confluence']['version']
      when '4.3.7' then node['confluence']['arch'] == 'x64' ? '03bb665b6abdc96495fca3f12683083d5e4633152f0c5cb4464779dcdd869f71' : '6612ab99ae0cf3ab240f9d9413a25bfe84b3f729cbb12ee4bee4e11a424513d0'
      when '5.0.1' then node['confluence']['arch'] == 'x64' ? '97f233a3d8f0cbedcdbdf10ce7a38cf72c091945a8281909e871828165b6ab8e' : 'b856b67564dade5930cae9590fd29ae15326e99e4b548a69b9e336d7e9659881'
      when '5.1' then node['confluence']['arch'] == 'x64' ? 'ac2cd3842b625ff6d451cf699c3b67685628cea2fd71dfbbcddcabd74f6f25eb' : '8b6acd4e807964b2c9f3fc9ced0c464183ee8ec73ddc3c8015dadb799be53c4c'
      when '5.1.1' then node['confluence']['arch'] == 'x64' ? '31bb76f8ed517c9828ada1f4a6d9b32db8eec8eb1a0ac9bf2474a861824a813f' : 'b77472844109da1a9b081d10191c77d6b6c0a50ea8ddc5ce1ddcb36a6320d14e'
      when '5.1.2' then node['confluence']['arch'] == 'x64' ? 'fc3b59471bf4ff95c4cae95e254b166c4d44b78d9d5464feb74361da7d00991c' : 'e4a7cd7545087796a12b91c577ef815ddace40f96d042d3027f22cf83ce1cace'
      when '5.1.3' then node['confluence']['arch'] == 'x64' ? '68ca52ad18a354ac721f38832088420591ebf4b7392b0e405194d7ebdc5b0e3f' : 'd2f674befaa4935c553616999efa6966e9ec0455f41026187ba50c38e05beb36'
      when '5.1.4' then node['confluence']['arch'] == 'x64' ? '5e055daf9a29c055b400df2d99aad8420433accd54a95b5c1067682ac393f25a' : '3262bb80a1e7a6df3c66b5dbbd5e26b7d3ab5941a6fb904f4ed890651933aa36'
      when '5.1.5' then node['confluence']['arch'] == 'x64' ? 'df477559705b72891385b38defa54032e1593bcf5271b3612fbcfbda86aac98e' : '3183183be7b5f0e0c5ea9af9dd562d0964abfa47d46e4720349c5b3e9339f80c'
      when '5.2.3' then node['confluence']['arch'] == 'x64' ? '5c518d54bcd06792a5eb7c62cbc031515c242fd944a0c6be64964b6d7f163bdc' : '09387b29824c507cc97fb662ff8b80dcf912c617b12420eed7b5cab3d0fa137f'
      when '5.2.5' then node['confluence']['arch'] == 'x64' ? 'c194abbc53142614adbdb0e3b6cc4a8a1106053563a02ab51a7c87189f502c1d' : 'd5efce4aaf0dccaaccdac2aeb35c2a7b025770bf05da2e84a4c89ad4de5c7b54'
      when '5.3' then node['confluence']['arch'] == 'x64' ? '4c61f3511ae3faeab11a689f26fbb82a7fc7c30525bd40c50e8854bc22b8e0be' : '5676b8fb7c8bbd1699f6cc5a8bcd7b72973bb98940bd0a56e13e5f96a6532c3d'
      when '5.5.2' then node['confluence']['arch'] == 'x64' ? '6b0361e2e25161f5e2d99380b397b5768fef835922dcb21ae34dfbc484bc203c' : '4e2ceb32cfa45085b184bbe08c7d4fbce6985487f9d12855e7fd4d0e60d9c78f'
      when '5.5.3' then node['confluence']['arch'] == 'x64' ? '0f091ecac293332f0841d80374090c5688fd413272e557d426d0b6809601030b' : '7e4be644b4fb9b58e5794029f0c733cc8537b3e1a8dd797949a8133c7d87ce73'
      when '5.6' then node['confluence']['arch'] == 'x64' ? '284a1afc2c6e22414766e7e140fed9821c81ed59cf32995ead2b4c4ecc9fa09f' : '7e3fc60e576e1a8109bb6eceb57797c0391ad81e1e025b75f19ed836846b49e2'
      when '5.6.1' then node['confluence']['arch'] == 'x64' ? '410c09200a7e81ba08e9ca27000140654e8ef1742b873456d3938ec6275aa161' : 'a0936d961c95f0c3c4e4c2f6721a46a632d03ffbfefb75f3d225689b3df76744'
      when '5.6.3' then node['confluence']['arch'] == 'x64' ? '7c9545d67dbafa4507603d9e5014ee8ba8975e057dff66edbf40acb85b92c6f8' : '7d252e8d9c092f56737a45d75b6c3643e30ce800e185981828e8419965001bb9'
      when '5.6.5' then node['confluence']['arch'] == 'x64' ? '76e882b9466068cbc3079870e97842d7823a88bc6b6a6e8cb934b6b4ad08872d' : '068e606b897e769209761c5b8097e9edf358b927109df4c4c58185e565ac2614'
      when '5.7' then node['confluence']['arch'] == 'x64' ? '3248c326a779007f9753cc1870330e2a09b8f2355466519d76ae3415b582ed52' : 'cb149a15d5052e17955042b6feaca55fabc3a76aa8b0afd19457c415fbed4540'
      when '5.7.1' then node['confluence']['arch'] == 'x64' ? '6144b112913d3114caaac93f5ee43191d22980ca704f3b53ef7725dff306d1ee' : '6c700207c0c2436f0bacf029a10f633e6d1980a60c7097773c56feec4df0b48b'
    end
when 'standalone'
  default['confluence']['url']      = "#{node['confluence']['url_base']}-#{node['confluence']['version']}.tar.gz"
  default['confluence']['checksum'] =
    case node['confluence']['version']
      when '4.3.7' then '18602095e4119cc5498ac14b4b5588e55f707cca73b36345b95c9a9e4c25c34d'
      when '5.0.1' then '18a497bf0899835d304e9a33431f347a28312e219d4555302e6332a3145b8191'
      when '5.1' then '3e6eced828d196bb6f18becb524c0191d4561308d71d85178fef84d5a6386203'
      when '5.1.1' then 'deb50f6dbc65b648fca9a7402d6e4ee60b0e779bbd4f1f33bc7b8344dead629e'
      when '5.1.2' then '291289c3ba7c2c59f3bcf36ca9962e022bc62946f7bdddf382529ae74242bfe2'
      when '5.1.3' then 'e400dadebe14a956d086dcb36deae2e6e12e0204ec9af49c176d62054c167903'
      when '5.1.4' then 'e615b1105c5a8a6cd16481d0e4467bd393b0a2065504a04975c5216cfd72d524'
      when '5.1.5' then '6dfbbc3404d8f96f203b01997fa7211cbf9eee491252d9f1cc5b2e84eb97f1ab'
      when '5.2.3' then '83b50558fa0f7c514b56ca56e73dbb337e725e1936b4cf2dd9c8a44b43a5e25e'
      when '5.2.5' then '98fef6163e0190d673b5ea4a3a2c8c3dd32e02d729361450515df2c4d5245892'
      when '5.3' then 'acc2f3c484bd1855b8c7c9d741da19d51a7595eed78d147d38c2c9aa63627f67'
      when '5.5.2' then '667190e9006de123e55ccc04e639321070dc65a40658ba3aa0b9d8e3473048eb'
      when '5.5.3' then '66538cba1a7925c82a2db5d438af27167c0a12dc02466d045a2f006f0f24d524'
      when '5.6' then 'a3738ea9da8012d7e93180732632d4bf782501cb25fccee960fccc6955117d68'
      when '5.6.1' then 'f8ff7ecdc742560ffeab4595200db26b3d1cb1bd0be9a93e418ae06fd6436e1c'
      when '5.6.3' then '63242c4df873f68461bcf071cf69a98fea07ec58a1e707ad5a5524cec77dcfdd'
      when '5.6.5' then '013b9fc8d20f5947637abefea1386532bb484134de57a70f7fd78d177352bd4d'
      when '5.7' then '2638d3c33585043168f6f22d7a05e09fde331d8a41080a600cd0f59c88b6ab0d'
      when '5.7.1' then '17eae4db5f08e7829f465aa6a98d7bcfe30d335afc97c52f57472c91bbe88da8'
    end
end
# rubocop:enable BlockNesting

default['confluence']['apache2']['access_log']         = ''
default['confluence']['apache2']['error_log']          = ''
default['confluence']['apache2']['port']               = 80
default['confluence']['apache2']['virtual_host_alias'] = node['fqdn']
default['confluence']['apache2']['virtual_host_name']  = node['hostname']

default['confluence']['apache2']['ssl']['access_log']       = ''
default['confluence']['apache2']['ssl']['chain_file']       = ''
default['confluence']['apache2']['ssl']['error_log']        = ''
default['confluence']['apache2']['ssl']['port']             = 443

case node['platform_family']
when 'rhel'
  default['confluence']['apache2']['ssl']['certificate_file'] = '/etc/pki/tls/certs/localhost.crt'
  default['confluence']['apache2']['ssl']['key_file']         = '/etc/pki/tls/private/localhost.key'
else
  default['confluence']['apache2']['ssl']['certificate_file'] = '/etc/ssl/certs/ssl-cert-snakeoil.pem'
  default['confluence']['apache2']['ssl']['key_file']         = '/etc/ssl/private/ssl-cert-snakeoil.key'
end

default['confluence']['database']['host']     = 'localhost'
default['confluence']['database']['name']     = 'confluence'
default['confluence']['database']['password'] = 'changeit'
default['confluence']['database']['type']     = 'mysql'
default['confluence']['database']['user']     = 'confluence'

default['confluence']['jvm']['minimum_memory']  = '256m'
default['confluence']['jvm']['maximum_memory']  = '512m'
default['confluence']['jvm']['maximum_permgen'] = '256m'
default['confluence']['jvm']['java_opts']       = ''

default['confluence']['tomcat']['keyAlias']     = 'tomcat'
default['confluence']['tomcat']['keystoreFile'] = "#{node['confluence']['home_path']}/.keystore"
default['confluence']['tomcat']['keystorePass'] = 'changeit'
default['confluence']['tomcat']['port']         = '8090'
default['confluence']['tomcat']['ssl_port']     = '8443'
