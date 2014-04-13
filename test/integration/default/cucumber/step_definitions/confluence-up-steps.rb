require 'faraday'
require 'nokogiri'

Given(/^the url of Confluences home page$/) do
  @host_header = 'https://confluence-installer-mysql-no-java-ubuntu-1204.vagrantup.com'.split('/').last
end

When(/^a web user browses to the url$/) do
  connection = Faraday.new(:url => "https://confluence-installer-mysql-no-java-ubuntu-1204.vagrantup.com",
                           :ssl => {:verify => false}) do |faraday|
    faraday.adapter Faraday.default_adapter
  end
  @page = Nokogiri::HTML(connection.get('/setup/setuplicense.action').body)
end

Then(/^the page should have the title "(.*?)"$/) do |title|
  expect(@page.title).to match /#{title}/
end
