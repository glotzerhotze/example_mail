#
# Cookbook:: example_mail
# Recipe:: _spf
#
# Copyright:: 2018, t.lo@klessen.cloud, All Rights Reserved.

## install packages
yum_package 'smf-spf'

## configure services
template '/etc/mail/smfs/smf-spf.conf' do
  action :create
  source 'smf-spf/smf-spf.conf.erb'
  owner 'root'
  group 'root'
  notifies :reload, 'service[smf-spf]', :delayed
end

## run service
service 'smf-spf' do
  supports status: true, restart: true, reload: false
  action %i[enable start]
end
