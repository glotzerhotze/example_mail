#
# Cookbook:: example_mail
# Recipe:: default
#
# Copyright:: 2018, t.lo@klessen.cloud, All Rights Reserved.

include_recipe 'example_mail::_certs'
include_recipe 'example_mail::_repo'
include_recipe 'example_mail::_postfix'
include_recipe 'example_mail::_dovecot'
include_recipe 'example_mail::_opendkim'
include_recipe 'example_mail::_spf'
include_recipe 'example_mail::_opendmarc'
## include_recipe 'example_mail::_dh'
include_recipe 'example_mail::_apache'
include_recipe 'example_mail::_postfixadmin'
include_recipe 'example_mail::_swaks'
