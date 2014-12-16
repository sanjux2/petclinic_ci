class mysql {

  package { "MariaDB-server":
    allow_virtual => false,
    ensure => installed,
  }

  package { "MariaDB-client":
    allow_virtual => false,
    ensure => installed,
  }

  service { "mysql":
    ensure => running,
    require => Package['MariaDB-server'],
  }

}

include mysql
