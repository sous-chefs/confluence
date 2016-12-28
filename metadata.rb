name 'confluence'
maintainer 'Mikhail Zholobov'
maintainer_email 'legal90@gmail.com'
license 'Apache 2.0'
description 'Installs/Configures Atlassian Confluence'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '2.2.0'

issues_url 'https://github.com/parallels-cookbooks/confluence/issues'
source_url 'https://github.com/parallels-cookbooks/confluence'

recipe 'confluence', 'Installs/configures Atlassian Confluence'
recipe 'confluence::apache2', 'Installs/configures Apache 2 as proxy (ports 80/443)'
recipe 'confluence::database', 'Installs/configures MySQL/PostgreSQL server, database, and user for Confluence'
recipe 'confluence::linux_installer', 'Installs/configures Confluence via Linux installer'
recipe 'confluence::linux_standalone', 'Installs/configures Confluence via Linux standalone archive'
recipe 'confluence::tomcat_configuration', "Configures Confluence's built-in Tomcat"
recipe 'confluence::crowd_sso', 'Configures user authentication with Crowd single sign-on'

supports 'amazon'
supports 'centos'
supports 'redhat'
supports 'scientific'
supports 'ubuntu'

depends 'apache2'
depends 'ark'
depends 'database'
depends 'java'
depends 'mysql', '< 8.0'
depends 'mysql_connector'
depends 'mysql2_chef_gem'
depends 'postgresql'
