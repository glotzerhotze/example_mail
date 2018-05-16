#
# Cookbook:: example_mail
# Recipe:: _opendkim
#
# Copyright:: 2018, t.lo@klessen.cloud, All Rights Reserved.

## install packages
yum_package 'opendkim'

## configure service
data_bag('opendkim').each do |item|
  opendkim_item = data_bag_item('opendkim', item)
  file "/etc/opendkim/#{opendkim_item['id']}.dkim.private" do
    content opendkim_item['key']
    action :create
    owner 'opendkim'
    group 'opendkim'
    mode '0600'
  end
end

template '/etc/internalhosts' do
  action :create
  source 'opendkim/internalhosts.erb'
  owner 'root'
  group 'root'
  notifies :reload, 'service[opendkim]', :delayed
end

template '/etc/opendkim.conf' do
  action :create
  source 'opendkim/opendkim.conf.erb'
  owner 'root'
  group 'root'
  notifies :reload, 'service[opendkim]', :delayed
end

opendkim_conf = %w[signtable keytable]

opendkim_conf.each do |config|
  template "/etc/opendkim/#{config}" do
    action :create
    source "opendkim/#{config}.erb"
    owner 'opendkim'
    group 'opendkim'
    notifies :reload, 'service[opendkim]', :delayed
  end
end

## run service
service 'opendkim' do
  supports status: true, restart: true, reload: true
  action %i[enable start]
end
