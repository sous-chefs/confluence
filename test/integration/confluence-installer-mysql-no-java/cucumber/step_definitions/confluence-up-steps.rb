require 'faraday'
require 'nokogiri'
require 'socket'

Given(/^the url of Confluences home page$/) do
  # the following code is really awful and really need to find out how to change it.
  @local_ip = Socket.ip_address_list[2].ip_address
end

When(/^a web user browses to the url$/) do
  connection = Faraday.new(:url => "https://#{@local_ip}",
                           :ssl => {:verify => false}) do |faraday|
    faraday.adapter Faraday.default_adapter
  end
  @title = Nokogiri::HTML(connection.get('/setup/setuplicense.action').body).title
end

Then(/^the page should have the title "(.*?)"$/) do |title|
  expect(@title).to match /#{title}/
end
