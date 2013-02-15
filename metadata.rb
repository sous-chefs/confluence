name              "confluence"
maintainer        "Brian Flad"
maintainer_email  "bflad@wharton.upenn.edu"
license           "Apache 2.0"
description       "Installs/Configures Atlassian Confluence"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.1.0"
recipe            "confluence", "Installs/Configures Atlassian Confluence"
recipe            "confluence::apache2", "Installs/Configures Atlassian Confluence behind Apache2"

%w{ amazon centos redhat scientific ubuntu }.each do |os|
  supports os
end

%w{ apache2 database java mysql mysql_connector postgresql }.each do |cb|
  depends cb
end
