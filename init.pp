#
# ==couchdb==
#

couchdb_app_name = 'couchdb' # Could be couchdb-version,etc.
couchdb_version = '1.2.0'

if ($::osfamily == Debian){

  user {'couchdb':
    ensure => present,
    gid => 'couchdb',
    comment => 'CouchDB Admin',
    system => true,
    uid => 598
    }

  file {["/var/lib/$couchdb_app_name","/var/log/$couchdb_app_name","/var/run/$couchdb_app_name"]:
    ensure => directory
      user => 'couchdb',
      group => 'couchdb',
      permissions => 0755
    }

  package {['make','wget','g++','erlang-base','erlang-dev','erlang-eunit','erlang-nox','libmozjs185-dev','libicu-dev','libcurl4-gnutls-dev','libtool','curl']:
    ensure => latest
    }
  ->
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
  exec {"/tmp/apache-couchdb-${couchdb_version}/configure --prefix=''":
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
}