# example_mail Cookbook

A Chef cookbook to setup a proper mail server for production usage.

## Sources for this Cookbook
https://dokuwiki.tachtler.net/doku.php?id=tachtler:postfix_centos_7
https://dokuwiki.nausch.org/doku.php/centos:mail_c7:start

Mad props to those two links above. Thanks the documentation of these two guys, most of this configuration was possible and is indeed shamelessly copied from their links above.

## Requirements

This was only tested on `CentOS-7` and you should probably already have the `epel-release` package installed.
Also, this setup assumes you are running your mail-server behind a `HAProxy` (eg. see dovecot / postfix config-templates).
Do check the `dovecot` LDAP setup and give a proper URL to your (eg. `freeIPA`) LDAP server.
For openDKIM, you need to setup keys in DNS for your domain to make things work.
Also, please double-check *all* config files and setup proper values for your environment, if things should not work out of the box.

## TODO
Some values (user-id, path for mail-user) are still hard-coded. This should probably be configurable via attributes.

## Authors

 - Tilo Klessen

 ## License

```text
2018 t.lo@klessen.cloud

MIT
```
