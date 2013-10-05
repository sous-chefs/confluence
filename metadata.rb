name              "confluence"
maintainer        "Brian Flad"
maintainer_email  "bflad@wharton.upenn.edu"
license           "Apache 2.0"
description       "Installs/Configures Atlassian Confluence"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "1.7.0"
recipe            "confluence", "Installs/configures Atlassian Confluence"
recipe            "confluence::apache2", "Installs/configures Apache 2 as proxy (ports 80/443)"
recipe            "confluence::database", "Installs/configures MySQL/Postgres server, database, and user for Confluence"
recipe            "confluence::linux_cluster-standalone", "Installs/configures Confluence Cluster via Linux standalone archive"
recipe            "confluence::linux_cluster-war", "Deploys Confluence Cluster WAR on Linux"
recipe            "confluence::linux_installer", "Installs/configures Confluence via Linux installer"
recipe            "confluence::linux_standalone", "Installs/configures Confluence via Linux standalone archive"
recipe            "confluence::linux_war", "Deploys Confluence WAR on Linux"
recipe            "confluence::tomcat_configuration", "Configures Confluence's built-in Tomcat"
recipe            "confluence::windows_cluster-standalone", "Installs/configures Confluence Cluster via Windows standalone archive"
recipe            "confluence::windows_cluster-war", "Deploys Confluence Cluster WAR on Windows"
recipe            "confluence::windows_installer", "Installs/configures Confluence via Windows installer"
recipe            "confluence::windows_standalone", "Installs/configures Confluence via Windows standalone archive"
recipe            "confluence::windows_war", "Deploys Confluence WAR on Windows"

%w{ amazon centos redhat scientific ubuntu }.each do |os|
  supports os
end

%w{ apache2 database mysql mysql_connector postgresql }.each do |cb|
  depends cb
end

%w{ java }.each do |cb|
  suggests cb
end
