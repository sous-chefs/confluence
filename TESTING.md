Cookbook TESTING doc
====================
Testing Prerequisites
---------------------
Chef cookbooks require either a working ChefDK installation set as your system's default ruby or Ruby 2.0+ with bundler installed. Using ChefDK provides a consistent Ruby install, and is the suggested method. ChefDK can be downloaded at https://downloads.chef.io/chef-dk/

To ensure all gems are updated to their latest releases run `bundle install; bundle update` before running any Rake testing tasks.

Integration testing relies on Hashicorp's [Vagrant](https://www.vagrantup.com/downloads.html) and
local virtualization system Oracle's [Virtualbox](https://www.virtualbox.org/wiki/Downloads), which must be installed first.

You can also use Vagrant with [Parallels Desktop for Mac](http://www.parallels.com/products/desktop/)
(with ["vagarnt-parallels"](https://github.com/Parallels/vagrant-parallels) plugin)

Rakefile
--------
The Rakefile ships with a number of tasks, each of which can be ran
individually, or in groups. Typing "rake" by itself will perform style
checks with Rubocop and Foodcritic, ChefSpec with rspec, and
integration with Test Kitchen using the Vagrant driver by
default. Alternatively, integration tests can be ran with Test Kitchen
cloud drivers.

```
$ rake -T
rake integration:vagrant      # Run Test Kitchen with Vagrant
rake spec                     # Run ChefSpec examples
rake style                    # Run all style checks
rake style:chef               # Run Chef style checks
rake style:ruby               # Run Ruby style checks
rake style:ruby:auto_correct  # Auto-correct RuboCop offenses
rake travis                   # Run all tests on Travis
```

Style Testing
-------------
Ruby style tests can be performed by Rubocop by issuing either
```
bundle exec rubocop
```
or
```
rake style:ruby
```

Chef style/correctness tests can be performed with Foodcritic by issuing either
```
bundle exec foodcritic
```
or
```
rake style:chef
```

Spec Testing
-------------
Unit testing is done by running Rspec examples. Rspec will test any
libraries, then test recipes using ChefSpec. This works by compiling a
recipe (but not converging it), and allowing the user to make
assertions about the resource_collection.

Integration Testing
-------------------
Integration testing is performed by Test Kitchen. Test Kitchen will
use either the Vagrant driver or various cloud drivers to instantiate
machines and apply cookbooks. After a successful converge, tests are
uploaded and ran out of band of Chef. Tests should be designed to
ensure that a recipe has accomplished its goal.

Integration Testing using Vagrant
---------------------------------
Integration tests can be performed on a local workstation using
Virtualbox or Parallels Desktop. Detailed instructions for setting this up can
be found at the [Bento](https://github.com/chef/bento) project web site.

Integration tests using Vagrant can be performed with either
```
bundle exec kitchen test
```
or
```
rake integration:vagrant
```
