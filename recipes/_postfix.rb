#
# Cookbook:: example_mail
# Recipe:: _postfix
#
# Copyright:: 2018, t.lo@klessen.cloud, All Rights Reserved.

## define data to be used
pgsql = data_bag_item('postgresql', 'postfix')

mail_password = pgsql['password']
mail_dbhost = node['example']['mail']['pgsql']['server']
mail_database = node['example']['mail']['pgsql']['database']
mail_username = node['example']['mail']['pgsql']['username']

## install packages
yum_package 'postfix'
yum_package 'postfix-pgsql'

## configure service
template '/etc/postfix/master.cf' do
  source 'postfix/master.cf.erb'
  owner 'root'
  group 'postfix'
  notifies :restart, 'service[postfix]', :delayed
end

template '/etc/postfix/main.cf' do
  source 'postfix/main.cf.erb'
  owner 'root'
  group 'postfix'
  notifies :restart, 'service[postfix]', :delayed
end

directory '/etc/postfix/pgsql' do
  action :create
  recursive true
  owner 'root'
  group 'postfix'
  mode '0755'
end

sql_queries = %w[virtual_mailbox_domains.cf virtual_mailbox_maps.cf virtual_domains_maps.cf virtual_alias_maps.cf virtual_alias_domain_maps.cf virtual_alias_domain_mailbox_maps.cf virtual_alias_domain_catchall_maps.cf]

sql_queries.each do |query|
  template "/etc/postfix/pgsql/#{query}" do
    source "postfix/pgsql/#{query}.erb"
    owner 'root'
    group 'postfix'
    sensitive true
    variables(
      username: mail_username,
      password: mail_password,
      host: mail_dbhost,
      database: mail_database
    )
    notifies :restart, 'service[postfix]', :delayed
  end
end

postmap = %w[
  access_helo
  access_recipient
  access_recipient-rfc
  access_sender
  lmtp_generic_maps
  recipient_bcc_maps
  recipient_canonical_maps
  relocated_maps
  sender_bcc_maps
  sender_canonical_maps
  smtp_generic_maps
  smtp_tls_policy_maps
  transport_maps
]

postmap.each do |template|
  template "/etc/postfix/#{template}" do
    source "postfix/#{template}.erb"
    owner 'root'
    group 'root'
    notifies :reload, 'service[postfix]', :delayed
  end

  execute "postfix-db-#{template}" do
    command "postmap /etc/postfix/#{template}"
    notifies :reload, 'service[postfix]', :delayed
  end
end

cidrmap = %w[
  access_client
  esmtp_access
  postscreen_white-blacklist
]

cidrmap.each do |template|
  template "/etc/postfix/#{template}" do
    source "postfix/#{template}.erb"
    owner 'root'
    group 'root'
    notifies :reload, 'service[postfix]', :delayed
  end
end

template '/etc/postfix/bounce.de-DE.cf' do
  source 'postfix/bounce.de-DE.cf.erb'
  owner 'root'
  group 'root'
  notifies :reload, 'service[postfix]', :delayed
end

template '/etc/aliases' do
  source 'postfix/aliases.erb'
  owner 'root'
  group 'root'
  notifies :reload, 'service[aliases]', :delayed
end

## User setup
group 'vmail' do
  action :create
  gid 22_222
end

## Group setup
user 'vmail' do
  comment 'mail system user'
  manage_home true
  home '/var/srv/mail/vmail'
  gid 22_222
  uid 22_222
  system true
  shell '/bin/false'
end

## run service
service 'postfix' do
  supports status: true, restart: true, reload: true
  action %i[enable start]
end

service 'aliases' do
  reload_command 'newaliases'
  supports reload: true
  action [:nothing]
  notifies :restart, 'service[postfix]', :delayed
end
