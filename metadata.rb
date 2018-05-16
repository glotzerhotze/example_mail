name 'example_mail'
maintainer 'Tilo Klessen'
maintainer_email 't.lo@klessen.cloud'
license 'MIT'
description 'Installs/Configures example_mail'
long_description 'Installs/Configures example_mail'
version '0.1.0'
chef_version '>= 13.5' if respond_to?(:chef_version)

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
issues_url 'https://github.com/glotzerhotze/example_mail/issues' if respond_to?(:issues_url)

# The `source_url` points to the development reposiory for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
source_url 'https://github.com/glotzerhotze/example_mail' if respond_to?(:source_url)

supports 'centos'
