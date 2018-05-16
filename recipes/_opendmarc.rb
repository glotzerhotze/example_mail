#
# Cookbook:: example_mail
# Recipe:: _opendmarc
#
# Copyright:: 2018, t.lo@klessen.cloud, All Rights Reserved.

## install packages
yum_package 'opendmarc'

## configure services
template '/etc/opendmarc.conf' do
  action :create
  source 'opendmarc/opendmarc.conf.erb'
  owner 'root'
  group 'root'
  notifies :reload, 'service[opendmarc]', :delayed
end

template '/etc/opendmarc/ignore.hosts' do
  action :create
  source 'opendmarc/ignore.hosts.erb'
  owner 'opendmarc'
  group 'opendmarc'
  notifies :reload, 'service[opendmarc]', :delayed
end

## run service
service 'opendmarc' do
  supports status: true, restart: true, reload: true
  action %i[enable start]
end
