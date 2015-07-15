---
layout: post
title: "Recovering Systems"
date: 2012-06-07 13:28
comments: true
categories: 
---

I inherited a bad IT system: out-of-support servers, end-of-life applications, snowflake configurations, forgotten customizations, no monitoring, and no inventory. I wasn't entirely surprised when I noticed that the directory service (OpenLDAP) was producing a zero-byte backup. It failed like this through the backup rotation window. We had no good backups on the machine, on the storage server, or offsite!

The scheduled backup job was not logging stderr and the service was not configured for logging, either. I hopped on the machine and tried

```
$ slapcat
```

The error appeared to be some corruption in the underlying database.

```text
bdb_db_open: unclean shutdown detected; attempting recovery.
bdb_db_open: Warning - No DB_CONFIG file found in directory /var/lib/ldap: (2)
Expect poor performance for suffix dc=foo.
bdb_db_open: Recovery skipped in read-only mode. Run manual recovery if errors are encountered.
bdb_db_open: alock_recover failed
bdb(dc=erx): Unknown locker ID: 0
bdb_db_close: alock_close failed
backend_startup_one: bi_db_open failed! (-1)
slap_startup failed
```

An explicit recovery command existed that would revert to the last checkpoint. 

```
$ slapd_db_recover
```

Unfortunately, checkpointing was not configured! We didn't know what this command would do, how long it would take, if it would succeed or destroy data. With no backups, this was a very risky situation.

We tried querying every record out of the running system, and creating our own backup (LDIF), hoping the system didn't fail under the stress.

```
$ ldapsearch -LLL
Size limit exceeded (4)
```

Oops, there are query limits hardcoded in the service configuration. I could have paged the results, but... c'mon.

```
-z sizelimit
       retrieve at most sizelimit entries for a search.  A sizelimit of 0 (zero) or  none  means
       no  limit.   A  sizelimit  of max means the maximum integer allowable by the protocol.  A
       server may impose a maximal sizelimit which only the root user may override.
```

We tried that special root service user, but no one had recorded the password.

```
$ ldapsearch -Wx -D "<rootdn>" -LLL
```

We could increase the query limit or reset the root service user's password in the service configuration, using a root machine user, but we'd have to restart the service for the configuration to change. Again, that wasn't safe without any backups.

It was time for an overblown technical response. We would archive the filesystem and load it in a virtual machine. We could try that recovery command, restart the service, or reconfigure to allow a full backup.

```
$ tar --create --verbose --gzip --file ldap.tar.gz /var/lib/ldap
```

Vagrant to the rescue! ... (snipped all the mess getting a CentOS 5.5 i386 image running)... We designed a simple Puppet manifest to install OpenLDAP, using default configurations.

```puppet
package { [
  'openldap',
  'openldap-servers',
]:
  ensure => latest,
}

file { '/var/lib/ldap':
  ensure  => directory,
  owner   => ldap,
  group   => ldap,
  mode    => 'u=rwx',
  require => Package['openldap-servers'],
}

service { 'ldap':
  ensure    => running,
  enable    => true,
  require   => File['/var/lib/ldap'],
}
```

We would stop the service, extract the backed up filesystem, and restart the service.

```
$ service ldap stop
$ tar --extract --file=ldap.tar.gz /var/lib/ldap
$ service ldap start
```

Wait a minute! The service restarted successfully despite the corrupted database. We now had some confidence that the corruption would be cleared up automatically.

We weren't out of the woods yet. We wanted to understand exactly how to load an empty directory service from a backup, just in case. We extracted a backup from the first virtual machine.

```
$ slapcat > backup.ldif
```

We started another Vagrant machine using that simple Puppet manifest and reloaded the data.

```
$ service ldap stop
$ slapadd -l backup.ldif
$ service ldap start
```

You're kidding...

```
str2entry: invalid value for attributeType objectClass #0 (syntax 1.3.6.1.4.1.1466.115.121.1.38)
slapadd: could not parse entry (line=12)
```

Of course, we had a custom schema with no changelog and, somehow, records in the directory service that didn't comply with that schema. Gah! This option didn't work as advertised.

```
-s     disable  schema checking.  This option is intended to be used when loading databases con-
       taining special objects, such as fractional objects on a partial replica.  Loading normal
       objects which do not conform to schema may result in unexpected and ill behavior.
```

We eventually figured out how to hand-edit the structure of the offending object to comply. With our hand-edited backup and recovery procedure ready, we set an off-hours maintenance period, notified the team, and restarted the directory service! Well, we were confident, so we let the machine do it.

```
> at midnight
service ldap restart
```

It worked and the backups started flowing! We also prioritized fixing some of those systemic problems...

 * Generated and securely stored a new password for the root service user (used `slappasswd` and the `rootpw` configuration directive).
 * Configured database checkpointing (the `checkpoint` configuration directive).
 * Configured service logging (the `logfile` configuration directive).
 
