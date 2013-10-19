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

class doinstall {
  include preparation
  include installrvm
}

include doinstall
