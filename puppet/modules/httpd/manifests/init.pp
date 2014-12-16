class httpd {

  package { "httpd.x86_64":
    allow_virtual => false,
    ensure => installed,
  }

  service { "httpd":
    ensure => running,
    require => Package['httpd.x86_64'],
  }

}

include httpd

