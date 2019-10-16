name 'confluence'
maintainer 'Azat Khadiev'
maintainer_email 'anuriq@gmail.com'
license 'Apache-2.0'
description 'Installs/Configures Atlassian Confluence'

version '2.5.1'

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

chef_version '< 13.0.0'
