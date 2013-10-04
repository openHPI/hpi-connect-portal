# development.pp

class preparation {
  group { "puppet": ensure => "present", }
  exec { "apt-update":
    command => "/usr/bin/apt-get -y update"
  }

  package {
    ["libpq-dev"]: 
      ensure => installed, require => Exec['apt-update']
  }
  
  file { "/etc/environment":
    content => inline_template("LANGUAGE=en_US.UTF-8\nLANG=en_US.UTF-8\nLC_ALL=en_US.UTF-8")
  }
}

class installrvm {
  include rvm
  
  rvm::system_user { vagrant: ; }
  
  rvm_system_ruby {
    'ruby-2.0.0-p247':
      ensure => 'present';
  }
}

class prepare_postgres {

  include postgresql::server
  
  postgresql::pg_hba_rule { 'allow postgres user to access any database':
      description => 'allow postgres user to access any database',
      type => 'local',
      database => 'all',
      user => 'postgres',
      auth_method => 'ident',
      order => '000',
  }

  postgresql::database_user{ 'ror_su':
    password_hash => postgresql_password('ror_su', 'us_ror'),
    superuser => true,
    require => Class['postgresql::server'],
  }
  
  exec { 'utf8 postgres':
    command => 'pg_dropcluster --stop 9.1 main ; pg_createcluster --start --locale en_US.UTF-8 9.1 main',
    unless  => 'sudo -u postgres psql -t -c "\l" | grep template1 | grep -q UTF',
    require => Class['postgresql::server'],
    path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
  }
}

class doinstall {
  include preparation
  include installrvm
  include prepare_postgres
}

include doinstall
