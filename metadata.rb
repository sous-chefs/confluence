name 'confluence'
maintainer 'Brian Flad'
maintainer_email 'bflad417@gmail.com'
license 'Apache 2.0'
description 'Installs/Configures Atlassian Confluence'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '1.7.1'

recipe 'confluence', 'Installs/configures Atlassian Confluence'
recipe 'confluence::apache2', 'Installs/configures Apache 2 as proxy (ports 80/443)'
recipe 'confluence::database', 'Installs/configures MySQL/Postgres server, database, and user for Confluence'
recipe 'confluence::linux_installer', 'Installs/configures Confluence via Linux installer'
recipe 'confluence::linux_standalone', 'Installs/configures Confluence via Linux standalone archive'
recipe 'confluence::tomcat_configuration', "Configures Confluence's built-in Tomcat"

supports 'amazon'
supports 'centos'
supports 'redhat'
supports 'scientific'
supports 'ubuntu'

depends 'apache2'
depends 'ark'
depends 'database', '~> 2.3'
depends 'mysql', '~> 6.0'
depends 'mysql_connector'
depends 'postgresql'

suggests 'jave'
