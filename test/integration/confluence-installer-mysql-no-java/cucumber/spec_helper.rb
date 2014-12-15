begin
  require 'faraday'
rescue LoadError
  require 'rubygems/dependency_installer'
  Gem::DependencyInstaller.new.install('faraday')
  require 'faraday'
end

begin
  require 'nokogiri'
rescue LoadError
  require 'rubygems/dependency_installer'
  Gem::DependencyInstaller.new.install('nokogiri')
  require 'nokogiri'
end
