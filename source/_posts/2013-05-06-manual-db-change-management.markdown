---
layout: post
title: "Manual Database Change Management"
date: 2013-05-06 14:33
comments: true
categories: practices, database
---

If you don't have a database change management workflow and you aren't using any tools, you need _something_, right? Some guidance, a structure, a starting point. You should be using a tool and you'd probably like to. Something like [Roundhouse][1] or [Liquibase][2] or... nevermind*. Until then, you have to make progress. You need to know when the upstream database is changed. You do have a test environment, right? And you need to be able to make and publicize your own changes.

## Getting Started

Given a new environment or workstation, how do you get started? Ideally, you'd have the entire database schema and reference data created from scripts. But, you likely have an existing database. So, start with a SQL backup (usually a `.BAK` file). That backup should be created from the upstream environment (test or production, your call, depending on where the most current database resides). Refer to the section on *Creating & Restoring a SQL Backup*.

It's probably too big to ever check into source control. So, stash it on a shared/network drive or on your project's collaboration site (Basecamp, SharePoint, Google Drive, etc). Create a decent folder structure for it in source control, like

    database/<database-name>/
    
Put the database backup in a sub-folder called `db/` and ignore that directory from source control. Restore that database in your local environment. You should create a directory called `up/` that will contain all of the _upgrade_ scripts for your database. Name them sequentially like

    <incrementing-int>_<alter/create/insert>_<description>.sql

If you're getting started and someone else on your team already created this structure, go ahead and execute each script in order. You might see scripts like

```
0001_create_foo.sql
0002_insert_foo_reference_data.sql
0003_alter_foo_constraint.sql
```

Voila! Your local instance should be up and running just like the upstream database.


## Making Database Changes

Now that you're up and running, you want to make changes to the database and propagate those upstream and to other team members. So, we're going make incremental SQL scripts and commit those to source control. There are several kinds of changes you may need to make

* Schema/DDL changes (add/remove columns, constraints, permissions, etc)
* Reference data (load/change lookup tables or catalogs)
* Transactional data (should be loaded by users, but may be needed for testing, demos, or development)

You may be able to write these by hand. If so, go ahead, I'll wait... Or, you can create your table with or without reference/transactional data, directly in your database tool. And, ask it to export it for you. In SQL Server Management Studio (SMSS), that looks like this

1. Right-click the table
1. Script Table as...
1. CREATE To... 
1. File... (create an incremental SQL script in the `up/` directory like 000X_create_foo.sql)
1. Right-click on the table
1. Script Table as...
1. INSERT To...
1. File... (create another incremental SQL script like 000Y_insert_foo_ref_data.sql)

And that can work for most changes. But, you can get into trouble, especially with a legacy database (that is, any system without tests or change management tooling), when you start making really gnarly changes. Like, adding an IDENTITY to an existing Primary Key column. A change like this is easy when you're letting a tool edit your local table. But, to deploy this properly involves temp tables, breaking/restoring constraints, and copying existing data... like I said, gnarly.

But, I found a feature in SSMS to auto-generate change scripts based on my manual modifications. Your tool may have the same feature.

1. Tools | Options | Designers | Table Options
1. Turn on "Auto generate change scripts"
1. Turn off "Prevent saving changes that require table re-creation"
1. Manually make your change in the Designer or Modify modes
1. Save or invoke the Generate Change Script option
1. Save to a file... (create an incremental SQL script like 000Z_alter_pk_identity.sql)

I encourage you to throw your change away so you can test the generated script (capture and restore a backup). I've had tools generate scripts that were missing required `USE <database-name>` statements.


## Committing and Publishing

Commit your incremental scripts to source control. Double check that you're not taking an ID that someone else already pushed. It's going to be a bit of a race, just like most changes. If you end up with a collision, chat with the other committer and figure out who has to increment their script.

If you're completely tested, committed, and pushed, connect to the upstream system and execute your change scripts (if you've got the permissions). It's a good idea to start teaching your QA and DB folks about your structure and system so they can be helpful migrating changes to non-developer-controlled systems.


## Creating/Restoring a SQL Backup

It's actually pretty easy to restore a backup from the command line. Just drop the existing table

    sqlcmd -Q "DROP DATABASE [<database-name>]"

And then restore like so (all of these commands have online references)

    sqlcmd -Q "RESTORE DATABASE [<database-name>] FROM DISK='path/to/bak'"

You can drop a database from the SSMS, as well.

1. Right-click on the database
1. Choose Delete
1. Check "Close existing connections"
1. Click Ok

Creating a backup is a little more involved. The SSMS dialog is brutal and I don't know how to do it from the command line.

1. Right-click on the database in SSMS
1. Choose Tasks | Back Up...
1. In the Options tab, choose, at least, "Compress backup" in the Compression options (In my experience, this is almost as good as ZIP archiving the backup, so you can skip that step!)
1. If you're backing up to an existing backup file and don't intend to add this backup to the existing "device", choose "Overwrite all existing backup sets." (SQL Server let's you stuff multiple backup "sets" into one backup file... it's odd, in my opinion)
1. Fight the Destination options to choose a file like `<database-name>_YYYYMMDD.bak`.
1. Click Ok

## Final Note
Remember what I said about using a tool? Good, now go [read][3] [up][4] on the [practices][5] and pick one!


<hr />
### Footnote
1. No one _wants_ to use Microsoft Database projects, or whatever they're called, the documentation is really bad over there. I'm not even sure how to get started.


 [1]: https://github.com/chucknorris/roundhouse
 [2]: http://www.liquibase.org/
 [3]: https://github.com/chucknorris/roundhouse/wiki
 [4]: https://github.com/chucknorris/roundhouse/wiki/RoundhousEModes
 [5]: https://groups.google.com/forum/?fromgroups=#!searchin/chucknorrisframework/roundhouse