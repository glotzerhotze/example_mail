#
# Cookbook:: example_mail
# Recipe:: _certs
#
# Copyright:: 2018, t.lo@klessen.cloud, All Rights Reserved.

ssl = data_bag_item(node['example']['postfix']['databag']['name'], node['example']['postfix']['databag']['item'])

%w[private certs misc].each do |dir|
  directory "/etc/pki/postfix/#{dir}" do
    action :create
    recursive true
    owner 'root'
    group 'root'
    mode '0644'
  end
end

file '/etc/pki/postfix/certs/mail.example.com.fullchain.pem' do
  content ssl['fullchain']
  action :create
  owner 'root'
  group 'root'
  mode '0644'
end

file '/etc/pki/postfix/certs/mail.example.com.chain.pem' do
  content ssl['chain']
  action :create
  owner 'root'
  group 'root'
  mode '0644'
end

file '/etc/pki/postfix/certs/mail.example.com.cert.pem' do
  content ssl['cert']
  action :create
  owner 'root'
  group 'root'
  mode '0644'
end

file '/etc/pki/postfix/private/mail.example.com.private.key.pem' do
  content ssl['key']
  sensitive true
  action :create
  owner 'root'
  group 'root'
  mode '0640'
end
