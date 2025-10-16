# Confluence Cookbook Changelog

## Unreleased

Standardise files with files in sous-chefs/repo-management


## [2.6.24](https://github.com/sous-chefs/confluence/compare/2.6.23...v2.6.24) (2025-10-15)


### Bug Fixes

* **ci:** Update workflows to use release pipeline ([#263](https://github.com/sous-chefs/confluence/issues/263)) ([3a53376](https://github.com/sous-chefs/confluence/commit/3a533761952c6f730e61dc8a62f64438934dd27f))

## 2.6.23 - *2025-09-04*

## 2.6.22 - *2024-11-18*

* Standardise files with files in sous-chefs/repo-management

## 2.6.21 - *2024-07-15*

* Standardise files with files in sous-chefs/repo-management

## 2.6.20 - *2024-05-01*

## 2.6.19 - *2024-05-01*

## 2.6.18 - *2023-10-03*

Fix markdown

## 2.6.17 - *2023-09-04*

## 2.6.16 - *2023-05-03*

## 2.6.15 - *2023-04-07*

Standardise files with files in sous-chefs/repo-management

## 2.6.14 - *2023-04-01*

## 2.6.13 - *2023-04-01*

## 2.6.12 - *2023-04-01*

Standardise files with files in sous-chefs/repo-management

## 2.6.11 - *2023-03-20*

Standardise files with files in sous-chefs/repo-management

## 2.6.10 - *2023-03-15*

Standardise files with files in sous-chefs/repo-management

## 2.6.9 - *2023-03-02*

## 2.6.8 - *2023-02-23*

Standardise files with files in sous-chefs/repo-management

## 2.6.7 - *2023-02-15*

## 2.6.6 - *2023-02-14*

Standardise files with files in sous-chefs/repo-management

## 2.6.5 - *2023-02-14*

## 2.6.4 - *2022-12-15*

* Standardise files with files in sous-chefs/repo-management
* Remove delivery folder

## 2.6.3 - *2021-09-08*

* resolved cookstyle error: recipes/configuration.rb:41:4 refactor: `Chef/Modernize/UseChefLanguageSystemdHelper`

## 2.6.2 - *2021-08-30*

* Standardise files with files in sous-chefs/repo-management

## 2.6.1 - *2021-06-01*

* Fixed ChefSpecs by replacing `node.set` with `node.default`
* Fixed Platform Family checks in the attributes that resulted in incorrect attributes being set

## 2.6.0 (2020/05/05)

* Fix a legacy ChefSpec
* Moved all templates out of the default directory
* Migrate to Github Actions
* resolved cookstyle error: libraries/helpers.rb:35:9 convention: `Style/RedundantReturn`
* resolved cookstyle error: libraries/helpers.rb:386:21 warning: `Lint/SendWithMixinArgument`
* resolved cookstyle error: libraries/helpers.rb:387:23 warning: `Lint/SendWithMixinArgument`
* resolved cookstyle error: libraries/helpers.rb:388:42 warning: `Lint/SendWithMixinArgument`
* resolved cookstyle error: recipes/autotune.rb:29:5 refactor: `ChefCorrectness/ChefApplicationFatal`
* resolved cookstyle error: recipes/linux_installer.rb:45:30 warning: `Lint/SendWithMixinArgument`
* resolved cookstyle error: recipes/linux_standalone.rb:37:21 warning: `Lint/SendWithMixinArgument`
* resolved cookstyle error: attributes/default.rb:50:1 refactor: `ChefStyle/UnnecessaryPlatformCaseStatement`
* resolved cookstyle error: libraries/helpers.rb:386:1 refactor: `ChefCorrectness/IncorrectLibraryInjection`
* resolved cookstyle error: libraries/helpers.rb:387:1 refactor: `ChefCorrectness/IncorrectLibraryInjection`

## 2.5.1 (2019/08/16)

* Update the owner information in metadata.rb
* Update CircleCI version
* Run cookstyle on repo (fixes #187)
* ISO-8601 date format for the CHANGLOG

## 2.5.0 (2019/03/10)

* Added version pin for Apache2

## 2.5.0 (2018/10/24)

* Added hash values to support for Confluence version `6.8.2`.

## 2.5.0 (2018/05/10)

* Changed cookbook ownership to Sous Chefs Community. Hopefully cookbook will come back to life.

## 2.4.3 (2017/07/12)

* Added hash values and support for Confluence versions `6.2.1`, `6.2.2`, `6.2.3`, `6.3.1`.
* Fix by style check suggestions.

## 2.4.2 (2017/05/31)

* Added hash values and support for Confluence versions `6.1.3`, `6.1.4` and `6.2.0`.

## 2.4.1 (2017/04/26)

* Added hash values and support for Confluence v6.1.2

## 2.4.0 (2017/04/06)

* Added hash values and support for Confluence v6.0.5 and v6.1.1
* Added restriction to avoid testing with Chef Client v13 for now

## 2.3.0 (2017/02/23)

* Added autotune feature for configuring jvm settings. see README.md for details. [[GH-140]](https://github.com/parallels-cookbooks/confluence/pull/140)
* Add temporary workaround for [CONF-35722](https://jira.atlassian.com/browse/CONF-35722). [[GH-148]](https://github.com/parallels-cookbooks/confluence/pull/148)

## 2.2.0 (2016/12/28)

Improvements:

* Added support of Confluence 5.10.4, 5.10.5, 5.10.6, 5.10.7, 5.10.8, 6.0.1,
  6.0.2.
  [[GH-127]](https://github.com/parallels-cookbooks/confluence/pull/127)
  [[GH-135]](https://github.com/parallels-cookbooks/confluence/pull/135)
* Added support of "hsqldb" database type
  [[GH-117]](https://github.com/parallels-cookbooks/confluence/pull/117)
  [[GH-119]](https://github.com/parallels-cookbooks/confluence/pull/119)
* Don't redirect /server-status for monitoring systems
  [[GH-128]](https://github.com/parallels-cookbooks/confluence/pull/128)

Bug fixes:

* Add a matching quote to JAVA_OPTS variable.
  [[GH-124]](https://github.com/parallels-cookbooks/confluence/pull/124)
* Fix initial service start after installing Confluence with .bin installer
  on systemd-driven systems.
  [[GH-136]](https://github.com/parallels-cookbooks/confluence/pull/136)

## 2.1.1 (2016/08/05)

Improvements:

* Added support of Confluence 5.10.2, 5.10.3.
  [[GH-118]](https://github.com/parallels-cookbooks/confluence/pull/118)
  [[GH-120]](https://github.com/parallels-cookbooks/confluence/pull/120)

## 2.1.0 (2016/06/13)

Backwards incompatibilities:

* Dropped support of Confluence < 5.5, since they've reached their EOL date.
  [[GH-106]](https://github.com/parallels-cookbooks/confluence/pull/106)
* Attribute `['confluence']['jvm']['maximum_permgen']` was removed, because
  it is not needed for Java 8.
  [[GH-114]](https://github.com/parallels-cookbooks/confluence/pull/114)

IMPROVEMENTS:

* Added attribute `['confluence']['jvm']['bundled_jre']` allowing to manage
  custom JRE by `java` cookbook regardless of `install_type`.
  [[GH-111]](https://github.com/parallels-cookbooks/confluence/pull/111)
* Added support of Confluence 5.9.9, 5.9.10, 5.10.1.
  [[GH-107]](https://github.com/parallels-cookbooks/confluence/pull/107)
  [[GH-115]](https://github.com/parallels-cookbooks/confluence/pull/115)
* Changed `mysql` cookbook constraint to work with newer version of
  `mysql2_chef_gem` cookbook.
  [[GH-109]](https://github.com/parallels-cookbooks/confluence/pull/109)
* Removes non-dynamic template for `web.xml` config.
  [[GH-116]](https://github.com/parallels-cookbooks/confluence/pull/116)

Bug fixes:

* postgres: Set "utf-8" encoding, "C" collation and "template0".
  [[GH-108]](https://github.com/parallels-cookbooks/confluence/pull/108)
* Fixed attributes for Apache listen ports.
  [[GH-103]](https://github.com/parallels-cookbooks/confluence/pull/103)
  [[GH-105]](https://github.com/parallels-cookbooks/confluence/pull/105)
* Fixed `conf` directory permissions.
  [[GH-99]](https://github.com/parallels-cookbooks/confluence/pull/99)

## 2.0.0 (2016/02/20)

BACKWARDS INCOMPATIBILITIES:

* Changed data bag layout
  [[GH-74]](https://github.com/parallels-cookbooks/confluence/pull/74)
* Cookbook dependency `mysql` is constraint to version 6 and higher
  [[GH-50]](https://github.com/parallels-cookbooks/confluence/pull/50)
* linux_installer: Use Java (JRE) bundled with Confluence installer
  [[GH-32]](https://github.com/parallels-cookbooks/confluence/pull/32)

IMPROVEMENTS:

* Added support for newer Confluence versions up to 5.9.5
  [[GH-24]](https://github.com/parallels-cookbooks/confluence/pull/24)
  [[GH-57]](https://github.com/parallels-cookbooks/confluence/pull/57)
  [[GH-79]](https://github.com/parallels-cookbooks/confluence/pull/79)
  [[GH-87]](https://github.com/parallels-cookbooks/confluence/pull/87)
  [[GH-94]](https://github.com/parallels-cookbooks/confluence/pull/94)
* Added support for Crowd SSO
  [[GH-26]](https://github.com/parallels-cookbooks/confluence/pull/26)
  [[GH-72]](https://github.com/parallels-cookbooks/confluence/pull/72)
  [[GH-75]](https://github.com/parallels-cookbooks/confluence/pull/75)
* Added support for `systemd`
  [[GH-45]](https://github.com/parallels-cookbooks/confluence/pull/45)
* library: Added helper methods for database connection
  [[GH-61]](https://github.com/parallels-cookbooks/confluence/pull/61)
* library: Added helper methods for Apache virtual host name and alias
  [[GH-81]](https://github.com/parallels-cookbooks/confluence/pull/81)
* apache: Redirect HTTP to HTTPS
  [[GH-73]](https://github.com/parallels-cookbooks/confluence/pull/73)
* apache: Added support for Apache 2.4
  [[GH-37]](https://github.com/parallels-cookbooks/confluence/pull/37)
* tomcat: Disable HTTPS on the Tomcat side
  [[GH-68]](https://github.com/parallels-cookbooks/confluence/pull/68)
* postgresql: Set database owner to confluence user
  [[GH-54]](https://github.com/parallels-cookbooks/confluence/pull/54)
* Allow to override apache webapp template in a wrapper cookbook
  [[GH-91]](https://github.com/parallels-cookbooks/confluence/pull/91)
* linux_standalone: Use `ark` resource to download and unpack Confluence
  .tar.gz artifact
  [[GH-40]](https://github.com/bflad/chef-confluence/issues/40)
* linux_installer: Update Confluence automatically using the installer
  [[GH-33]](https://github.com/parallels-cookbooks/confluence/pull/33)
  [[GH-49]](https://github.com/parallels-cookbooks/confluence/pull/49)
* Removed unused template for `confluence.cfg.xml`
  [[GH-41]](https://github.com/bflad/chef-confluence/issues/41)
* Removed unsupported and non-implemented installer types
  [[GH-27]](https://github.com/parallels-cookbooks/confluence/pull/27)

Bug fixes:

* Fixed issues of derived attributes
  [[GH-30]](https://github.com/parallels-cookbooks/confluence/pull/30)
  [[GH-31]](https://github.com/parallels-cookbooks/confluence/pull/31)
  [[GH-62]](https://github.com/parallels-cookbooks/confluence/pull/62)
  [[GH-64]](https://github.com/parallels-cookbooks/confluence/pull/64)
* linux_standalone: Fixed permissions on Confluence installation directory
  [[GH-71]](https://github.com/parallels-cookbooks/confluence/pull/71)
* linux_installer: Fixed issue of upgrade to the newer Confluence version
  [[GH-33]](https://github.com/parallels-cookbooks/confluence/pull/33)
  [[GH-49]](https://github.com/parallels-cookbooks/confluence/pull/49)
* library: Fix merging `settings` hashes from attribute and data bag.
  [[GH-23]](https://github.com/parallels-cookbooks/confluence/pull/23)
* mysql: Fixed install path of MySQL JDBC connector
  [[GH-52]](https://github.com/parallels-cookbooks/confluence/pull/52)
* mysql: Fixed "RecipeNotFound" caused by invalid cookbook dependencies
  [[GH-19]](https://github.com/parallels-cookbooks/confluence/pull/19)
* Fixed apache default settings for `ServerName` and `ServerAlias` directives
  [[GH-47]](https://github.com/parallels-cookbooks/confluence/pull/47)
  [[GH-89]](https://github.com/parallels-cookbooks/confluence/pull/89)

## 1.7.1 (2014/01/02)

Bug fixes:

* Fixed chef-solo run failure with `java_ark` resource notification [[GH-2]](https://github.com/parallels-cookbooks/confluence/issues/2)

## 1.7.0 (2013/10/05)

* Bump default version of Confluence to 5.3

## 1.6.0 (2013/08/21)

* Bump default version of Confluence to 5.2.3

## 1.5.0 (2013/08/08)

* Bump default version of Confluence to 5.1.5

## 1.4.0 (2013/07/24)

* Bump default version of Confluence to 5.1.4

## 1.3.0 (2013/05/16)

* Bump default version of Confluence to 5.1.3

## 1.2.1 (2013/04/16)

* Fix Apache log file names

## 1.2.0 (2013/03/29)

* Bump default version of Confluence to 5.1.0
* Update Vagrant box URLs to Chef 11.2.0 since its tested and works

## 1.1.0 (2013/02/28)

* Bump default version of Confluence to 5.0.1

## 1.0.0 (2013/02/16)

* Production ready with Linux installer/standalone installs
* Split out individual recipes for installation and configuration
* Default recipe now includes Apache 2 proxy
* Built-in checksum handling
* Moved apache2 attributes into default attributes

## 0.1.0

* Initial beta release
