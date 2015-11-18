# Contributing to Parallels Cookbooks

We're glad you want to contribute to Parallels Cookbooks! The first
step is the desire to improve the project.

## Quick Contributing Steps

1. Create an account on [GitHub](https://github.com).
2. Create a pull request for your change on [GitHub](https://github.com).
3. The community cookbook maintainers will review your change, and either merge
the change or offer suggestions.

## Using git

You can copy a chef cookbook repository to your local workstation by running
`git clone git://github.com/parallels-cookbooks/COOKBOOKNAME.git`.

For collaboration purposes, it is best if you create a GitHub account
and fork the repository to your own account. Once you do this you will
be able to push your changes to your GitHub repository for others to
see and use.

If you have another repository in your GitHub account named the same
as the cookbook, we suggest you suffix the repository with `-cookbook`.

### Branches and Commits

You should submit your patch as a git branch named after the Github
issue, such as GH-22. This is called a _topic branch_ and allows users
to associate a branch of code with the ticket.

It is a best practice to have your commit message have a _summary
line_ that includes the ticket number, followed by an empty line and
then a brief description of the commit. This also helps other
contributors understand the purpose of changes to the code.

```text
    [GH-22] - platform_family and style

    * use platform_family for platform checking
    * update notifies syntax to "resource_type[resource_name]" instead of
      resources() lookup
    * GH-692 - delete config files dropped off by packages in conf.d
    * dropped debian 4 support because all other platforms have the same
      values, and it is older than "old stable" debian release
```

Remember that not all users use Chef in the same way or on the same
operating systems as you, so it is helpful to be clear about your use
case and change so they can understand it even when it doesn't apply
to them.

### More information

Additional help with git is available on the [Community
Contributions](https://docs.chef.io/community_contributions.html#use-git)
page on the Chef Docs site.

## Functional and Unit Tests

Chef cookbooks are tested with functional and unit tests to ensure
changes don't cause regressions for other use cases.  Ideally all
changes include either functional or unit tests.  See the TESTING.md
file for additional information on testing in chef cookbooks.

## Code Review

Cookbook maintainers regularly review code contributions and provide suggestions
for improvement in the code itself or the implementation.

## Release Cycle

The versioning for Parallels cookbooks is X.Y.Z.

* X is a major release, which may not be fully compatible with prior major
releases
* Y is a minor release, which adds both new features and bug fixes
* Z is a patch release, which adds just bug fixes

See the [Cookbook Versioning Policy](https://chef-community.github.io/cvp/) for
more guidance on semantic versioning of cookbooks.

## Working with the community

These resources will help you learn more about Chef and connect to
other members of the Chef community:

* [Chef Community Guidelines](https://docs.chef.io/community_guidelines.html)
* [Chef Mailing List](https://discourse.chef.io/c/dev)
* #chef and #chef-hacking IRC channels on irc.freenode.net
* [Supermarket site](https://supermarket.chef.io)
* [Chef Docs](https://docs.chef.io)

## Contribution Do's and Don't's

Please do include tests for your contribution. If you need help, ask
on the
[chef-dev mailing list](https://discourse.chef.io/c/dev)
or the
[#chef-hacking IRC channel](https://community.chef.io/chat/chef-hacking).
Not all platforms that a cookbook supports may be supported by Test
Kitchen. Please provide evidence of testing your contribution if it
isn't trivial so we don't have to duplicate effort in testing.

Please do indicate new platform (families) or platform versions in the
commit message, and update the relevant ticket.

Please do ensure that your changes do not break or modify behavior for
other platforms supported by the cookbook. For example if your changes
are for Debian, make sure that they do not break on CentOS.

Please do **not** modify the version number in the `metadata.rb`, cookbook
maintainers will select the appropriate version based on the release cycle
information above.

Please do **not** update the `CHANGELOG.md` for a new version. Not all
changes to a cookbook may be merged and released in the same versions.
Cookbook maintainers will update the `CHANGELOG.md` when releasing a new
version of the cookbook.
