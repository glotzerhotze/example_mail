#
# Cookbook:: example_mail
# Recipe:: _repo
#
# Copyright:: 2018, t.lo@klessen.cloud, All Rights Reserved.

yum_repository 'mailguru-stable' do
  description 'MailGuru Stable Repository'
  baseurl 'http://repo.mailserver.guru/7/os/x86_64'
  gpgkey 'http://repo.mailserver.guru/7/MAILSERVER.GURU-RPM-GPG-KEY-CentOS-7'
  action :create
end

yum_repository 'mailguru-testing' do
  description 'MailGuru Stable Repository'
  baseurl 'http://repo.mailserver.guru/7/testing/x86_64'
  gpgkey 'http://repo.mailserver.guru/7/MAILSERVER.GURU-RPM-GPG-KEY-CentOS-7'
  action :create
end
