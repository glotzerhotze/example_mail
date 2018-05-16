#
# Cookbook Name:: example_mail
# Recipe:: _apache
#
# Copyright:: 2018, t.lo@klessen.cloud, All Rights Reserved.

case node['platform']

when 'centos', 'redhat', 'fedora', 'scientific'

  remote_file '/root/ius-release.rpm' do
    source 'https://centos7.iuscommunity.org/ius-release.rpm'
    owner 'root'
    group 'root'
    mode '0755'
    action :create
  end

  yum_package 'ius-release' do
    source '/root/ius-release.rpm'
  end

  ## install packages
  %w[httpd php71u-cli php71u-pgsql php71u-pdo php71u-mbstring php71u-imap php71u-fpm php71u-common mod_php71u].each do |pkg|
    yum_package pkg
  end

  ## define vhosts
  vhosts = node['example']['mail']['apache']['vhosts']

  ## create directory structure
  vhosts.each do |vhost|
    %w[htdocs logs cgi-bin].each do |path|
      directory "/var/www/#{vhost}/#{path}" do
        recursive true
        owner 'apache'
        group 'apache'
        mode '0755'
        action :create
      end
    end

    template "/var/www/#{vhost}/htdocs/index.html" do
      source 'apache2/index.html.erb'
      mode '0644'
      owner 'root'
      group 'root'
      variables(
        vhost: vhost
      )
      notifies :reload, 'service[httpd]', :delayed
    end

    template "/etc/httpd/conf.d/#{vhost}.conf" do
      source 'apache2/vhost.conf.erb'
      mode '644'
      owner 'root'
      group 'root'
      variables(
        vhost: vhost
      )
      notifies :reload, 'service[httpd]', :delayed
    end
  end

  template '/etc/httpd/conf/httpd.conf' do
    source 'apache2/httpd.conf.erb'
    mode '644'
    owner 'root'
    group 'root'
    notifies :reload, 'service[httpd]', :delayed
  end

  service 'httpd' do
    supports restart: true, reload: true
    action %i[enable start]
  end
end
