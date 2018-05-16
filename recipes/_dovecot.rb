#
# Cookbook:: example_mail
# Recipe:: _dovecot
#
# Copyright:: 2018, t.lo@klessen.cloud, All Rights Reserved.

## define data to be used
mail = data_bag_item('postgresql', 'postfix')
ldap = data_bag_item('ldap', 'ldap.bind')

mail_password = mail['password']
mail_dbhost = node['example']['mail']['pgsql']['server']
mail_database = node['example']['mail']['pgsql']['database']
mail_username = node['example']['mail']['pgsql']['username']

## install packages
yum_package 'dovecot'
yum_package 'dovecot-pgsql'
yum_package 'dovecot-pigeonhole'

## configure service
template '/etc/dovecot/dovecot.conf' do
  action :create
  source 'dovecot/dovecot.conf.erb'
  owner 'root'
  group 'dovecot'
  notifies :reload, 'service[dovecot]', :delayed
end

template '/etc/dovecot/dovecot-ldap.conf.ext' do
  action :create
  source 'dovecot/dovecot-ldap.conf.ext.erb'
  owner 'root'
  group 'dovecot'
  sensitive true
  variables(
    user: ldap['id'],
    password: ldap['password']
  )
  notifies :reload, 'service[dovecot]', :delayed
end

template '/etc/dovecot/dovecot-sql.conf.ext' do
  action :create
  source 'dovecot/dovecot-sql.conf.ext.erb'
  owner 'root'
  group 'dovecot'
  sensitive true
  variables(
    username: mail_username,
    password: mail_password,
    host: mail_dbhost,
    database: mail_database
  )
  notifies :reload, 'service[dovecot]', :delayed
end

dovecot_confd = %w[10-auth.conf 10-mail.conf 10-master.conf 10-ssl.conf auth-ldap.conf]

dovecot_confd.each do |config|
  template "/etc/dovecot/conf.d/#{config}" do
    action :create
    source "dovecot/conf.d/#{config}.erb"
    owner 'root'
    group 'dovecot'
    notifies :reload, 'service[dovecot]', :delayed
  end
end

## run service
service 'dovecot' do
  supports status: true, restart: true, reload: true
  action %i[enable start]
end
