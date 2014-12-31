begin
  require 'faraday'
rescue LoadError
  require 'rubygems/dependency_installer'
  Gem::DependencyInstaller.new.install('faraday')
  require 'faraday'
end