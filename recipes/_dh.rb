#
# Cookbook:: example_mail
# Recipe:: _dh
#
# Copyright:: 2018, t.lo@klessen.cloud, All Rights Reserved.

directory '/etc/pki/tls/tmp' do
  recursive true
  action :create
  owner 'root'
  group 'root'
end

template '/usr/local/bin/edh_keygen' do
  source 'edh_keygen.erb'
  owner 'root'
  group 'root'
  mode '0755'
end

cron 'edh_keygen' do
  hour '5'
  minute '0'
  command '/usr/local/bin/edh_keygen'
end
