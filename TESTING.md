# Cookbook TESTING doc

## Testing Prerequisites

Chef cookbooks require either a working ChefDK installation set as your system's
default ruby or Ruby 2.0+ with bundler installed. Using ChefDK provides
a consistent Ruby install, and is the suggested method.
ChefDK can be downloaded at https://downloads.chef.io/chef-dk/

Integration testing relies on Hashicorp's [Vagrant](https://www.vagrantup.com/downloads.html)
and local virtualization system Oracle's [Virtualbox](https://www.virtualbox.org/wiki/Downloads),
which must be installed first.

You can also use Vagrant with [Parallels Desktop for Mac](http://www.parallels.com/products/desktop/)
(with ["vagarnt-parallels"](https://github.com/Parallels/vagrant-parallels) plugin)

## Installing dependencies

Cookbooks may require additional testing dependencies that do not ship with
ChefDK directly. These can be installed into the ChefDK ruby environment with
the following commands

Install dependencies:

```shell
chef exec bundle install
```

Update any installed dependencies to the latest versions:

```shell
chef exec bundle update
```

## Rakefile

The Rakefile ships with a number of tasks, each of which can be ran
individually, or in groups. Typing "rake" by itself will perform the default
checks: style checks (Rubocop and Foodcritic), and unit tests (Chefspec).
To see a complete list of available tasks run `rake -T`


```
$ rake -T
rake integration:             # Run kitchen integration tests
rake spec                     # Run ChefSpec examples
rake style                    # Run all style checks
rake style:chef               # Run Chef style checks
rake style:ruby               # Run Ruby style checks
rake style:ruby:auto_correct  # Auto-correct RuboCop offenses
```


## Spec Testing

Unit testing is done by running Rspec examples. Rspec will test any libraries,
then test recipes using ChefSpec. This works by compiling a recipe (but not
converging it), and allowing the user to make assertions about the resource_collection.

## Integration Testing

Integration testing is performed by Test Kitchen. After a successful converge,
tests are uploaded and ran out of band of Chef. Tests should be designed to
ensure that a recipe has accomplished its goal.

## Integration Testing using Vagrant

Integration tests can be performed on a local workstation using either
Virtualbox or Parallels Desktop as the virtualization hypervisor. To run tests
against all available instances run:

```shell
rake integration:vagrant
```

To see a list of available test instances run:

```shell
chef exec kitchen list
```

To test specific instance run:

```shell
chef exec kitchen test INSTANCE_NAME
```
