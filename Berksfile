source 'https://supermarket.chef.io'

metadata

group :integration do
  cookbook 'apt'
  cookbook 'java'
  cookbook 'confluence_test', path: 'test/fixtures/cookbooks/confluence_test'
end

# Temporary lock. Remove it when this PR is merged and released:
# https://github.com/sous-chefs/postgresql/pull/396
cookbook 'postgresql', '= 5.1.0'
