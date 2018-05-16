default['example']['mail']['postfix']['mynetwork'] = '10.1.2.0/16'

default['example']['mail']['apache']['vhosts'] = 'postfixadmin'
default['example']['mail']['pgsql']['server'] = 'pgsql.example.com'
default['example']['mail']['pgsql']['database'] = 'postfix'
default['example']['mail']['pgsql']['username'] = 'postfix'

default['example']['postfix']['databag']['name'] = 'certs'
default['example']['postfix']['databag']['item'] = 'mail.example.com'
