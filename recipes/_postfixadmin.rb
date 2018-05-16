#
# Cookbook Name:: example_mail
# Recipe:: _postfixadmin
#
# Copyright:: 2018 t.lo@klessen.cloud, All Rights Reserved.

deployed = <<-EOF
    cat /var/www/postfixadmin/htdocs/index.php | grep "php"
EOF

pgsql_user = data_bag_item('postgresql', 'postfix')

remote_file '/var/www/postfixadmin/postfixadmin-3.1.tar.gz' do
  source 'https://sourceforge.net/projects/postfixadmin/files/postfixadmin/postfixadmin-3.1/postfixadmin-3.1.tar.gz/download'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
  not_if deployed
end

execute 'untar-postfixadmin' do
  command 'tar xvf /var/www/postfixadmin/postfixadmin-3.1.tar.gz -C /var/www/postfixadmin'
  not_if deployed
end

execute 'move-postfixadmin-source-to-webroot' do
  command 'mv /var/www/postfixadmin/postfixadmin-3.1/* /var/www/postfixadmin/htdocs && rmdir /var/www/postfixadmin/postfixadmin-3.1'
  not_if deployed
end

directory '/var/www/postfixadmin/htdocs/templates_c' do
  owner 'apache'
  group 'apache'
  mode '0755'
  action :create
end

# execute 'set-selinux-policy-for-templates_c' do
#   command 'chcon -R -t httpd_sys_content_rw_t /var/www/postfixadmin/htdocs/templates_c/'
# end

# execute 'set-selinux-policy-for-postfixadmin' do
#   command "for file in `ls -Z /var/www/postfixadmin/htdocs | grep unlabel | awk -F\" \" '{print $5}'`; do chcon -Rv system_u:object_r:httpd_sys_content_t:s0 $file; done"
# end

## disable SELinux for now, as postfixadmin won't work without proper SELinux rule-set
execute 'set-selinux-to-permissive' do
  command 'setenforce 0'
end

## might break if user already exists with UUID 1000
execute 'set-postfixadmin-webroot-permissions' do
  command 'chown apache.apache /var/www/postfixadmin/htdocs -R'
  only_if 'ls -latr /var/www/postfixadmin/htdocs/config.inc.php | grep 1000'
end

template '/var/www/postfixadmin/htdocs/config.local.php' do
  source 'postfixadmin/config.local.php.erb'
  owner 'apache'
  group 'apache'
  mode '0640'
  sensitive true
  variables(
    dbname: 'postfix',
    user: pgsql_user['id'],
    password: pgsql_user['password'],
    host: node['example']['mail']['pgsql']['server']
  )
end
