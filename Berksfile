source 'https://supermarket.chef.io'

metadata

group :integration do
  cookbook 'apt'
  cookbook 'java'
  cookbook 'confluence_test', path: 'test/fixtures/cookbooks/confluence_test'

  # Lock 'postgresql' version due to the issue of derived attributes
  # https://github.com/hw-cookbooks/postgresql/issues/302
  cookbook 'postgresql', '= 3.4.16'
end
