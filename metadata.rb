name 'confluence'
maintainer 'Sous-Chef'
maintainer_email 'help@sous-chefs.org'
license 'Apache-2.0'
description 'Installs/Configures Atlassian Confluence'
chef_version '< 13.0.0'
version '2.6.12'

issues_url 'https://github.com/sous-chefs/confluence/issues'
source_url 'https://github.com/sous-chefs/confluence'

supports 'amazon'
supports 'centos'
supports 'redhat'
supports 'scientific'
supports 'ubuntu'

depends 'apache2', '< 6.0.0'
depends 'ark'
depends 'database'
depends 'java'
depends 'mysql', '< 8.0.0'
depends 'mysql_connector'
depends 'mysql2_chef_gem', '< 2.0.0'
depends 'postgresql'
