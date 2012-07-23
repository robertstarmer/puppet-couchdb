puppet-couchdb
==============

Puppet Module to support installing CouchDB

Since at least the Ubuntu repository doesn't have a current version of CouchDB (still at 1.0.1 vs. 1.2) we will build from source.

Quick Install
-------------

	sudo apt-get install curl
	bash < <(curl -s -k -B https://raw.github.com/robertstarmer/puppet-couchdb/master/couchdb_setup)

This is based on the instructions found here:
https://onabai.wordpress.com/2012/05/10/installing-couchdb-1-2-in-ubuntu-12-04/

This file and others as a part of the puppet-couch project by Robert Starmer is licensed under a Creative Commons Attribution-ShareAlike 3.0 Unported License.
