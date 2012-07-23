#
# ==couchdb==
# This file and others as a part of the puppet-couch project by Robert Starmer is licensed under a Creative Commons Attribution-ShareAlike 3.0 Unported License.
#
# =class couchdb=
#
# $couchdb_add_name = couchdb , this likely shouldn't change, though some folks may want multiple versions running
# $couchdb_version = 1.2.0, the version number of the couchdb instance
#
# =example=
#
# couchdb {"couchdb":
#   }
#
define couchdb (
$couchdb_app_name = 'couchdb'
$couchdb_version = '1.2.0'
) {
  if ($::osfamily == Debian){

    user {'couchdb':
      ensure => present,
      gid => 'couchdb',
      comment => 'CouchDB Admin',
      system => true,
      uid => 598
    }
    <-
    group {'couchdb':
      ensure => present,
      name => 'couchdb',
      system => true,
      gid => 598
    }

    package { ['make', 'wget','g++', 'erlang-base', 'erlang-dev', 'erlang-eunit', 'erlang-nox', 'libmozjs185-dev', 'libicu-dev', 'libcurl4-gnutls-dev', 'libtool', 'curl' ]:
      ensure => latest
      }

    exec {"/usr/bin/wget http://mirror.uoregon.edu/apache/couchdb/releases/${couchdb_version}/apache-couchdb-${couchdb_version}.tar.gz":
      cwd => '/tmp',
      path => ['/bin','/usr/bin'],
      creates => "/tmp/apache-couchdb-${couchdb_version}.tar.gz"
    }
    ->
    exec {"/bin/tar xfz /tmp/apache-couchdb-${couchdb_version}.tar.gz":
      cwd => '/tmp',
      path => ['/bin','/usr/bin'],
      creates => '/tmp/apache-couchdb-${couchdb_version}'
    }
    ->
    exec {"/tmp/apache-couchdb-${couchdb_version}/configure --srcdir=/tmp/apache-couchdb-${couchdb_version} --prefix='' ":
      cwd => "/tmp/apache-couchdb-${couchdb_version}",
      path => ['/bin','/usr/bin','/tmp/apache-couchdb-${couchdb_version}'],
      creates => '/tmp/apache-couchdb-${couchdb_version}/config.status'
    }
    ->
    exec {"/usr/bin/make && /usr/bin/make install":
      cwd => "/tmp/apache-couchdb-${couchdb_version}",
      path => ['/bin','/usr/bin','/tmp/apache-couchdb-${couchdb_version}'],
      creates => "/bin/${couchdb_app_name}"
    }
    ->
    exec {"/usr/sbin/update-rc.d couchdb defaults":
      cwd => '/tmp',
      path => ['/bin','/usr/bin','/usr/sbin'],
      creates => "/etc/rc3.d/S20couchdb"
    }
    ->
    exec {"/bin/sed -e 's/;bind_address.*/bind_address = 0.0.0.0/' -i /etc/couchdb/local.ini":
      cwd => '/tmp',
      path => ['/bin','/usr/bin'],
      unless => "/bin/grep 'bind_address = 0.0.0.0' 2>/dev/null"
    }


    file { ["/var/lib/${couchdb_app_name}", "/var/log/${couchdb_app_name}", "/var/run/${couchdb_app_name}"]:
        ensure => directory,
        owner => 'couchdb',
        group => 'couchdb',
        mode => 0755
      }
  
    file { ["/var/lib/${couchdb_app_name}/_replicator.couch", "/var/lib/${couchdb_app_name}/_users.couch", "/var/log/${couchdb_app_name}/couchdb.log"]:
      ensure => present,
      owner => 'couchdb',
      group => 'couchdb',
      mode => 0755
    }
 
    service {'couchdb':
      ensure => running
    }
  }
}