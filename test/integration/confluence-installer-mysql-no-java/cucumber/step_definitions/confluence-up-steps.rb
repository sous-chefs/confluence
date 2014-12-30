# encoding: UTF-8
 
# Faraday is a simple, but flexible HTTP client library, with support for
# multiple backends. We will use it here to read the serveur's response 
# that we want to verify.
require 'faraday'
# We use the Socket library to find out the IP of the serveur in order to
# form the url to test.
require 'socket'

Given(/^the url of Confluences home page$/) do
  # TODO the following code is really awful and really need to find out how to change it.
  # Possible way : use ohai localy.
  local_ip = Socket.ip_address_list[2].ip_address
  if local_ip == '::1' 
    local_ip = Socket.ip_address_list[1].ip_address
  end 
  @confluence_url = "https://#{local_ip}"
  puts "Confluence's Home Page Url: #{@confluence_url}"
end

When(/^a web user browses to the url$/) do
  connection = Faraday.new(:url => @confluence_url,
                           :ssl => { :verify => false }) do |faraday|
    faraday.adapter Faraday.default_adapter
  end
  @response = connection.get('/setup/setuplicense.action')
end

Then(/^the connection should be successful$/) do
  expect(@response.success?).to be true
end

Then(/^the page status should be OK$/) do
  expect(@response.status).to eq(200)
end

Then(/^the page should have the title "(.*?)"$/) do |title|
  page_title = @response.body.match(/<title>(.*?)<\/title>/)[1]
  expect(page_title).to match(title)
end
