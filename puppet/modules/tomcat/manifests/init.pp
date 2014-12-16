group { 'puppet': ensure => 'present' }

class openjdk {

  package { "java-1.6.0-openjdk-devel.x86_64":
    allow_virtual => false,
    ensure => installed,
  }
}

class tomcat {
 
  package { "tomcat":
    allow_virtual => false,
    ensure => installed,
    require => Package['java-1.6.0-openjdk-devel.x86_64'],
  }

  package { "tomcat-admin-webapps.noarch":
    allow_virtual => false,
    ensure => installed,
    require => Package['tomcat'],
  }

  service { "tomcat":
    ensure => running,
    require => Package['tomcat'],
    subscribe => File["mysql-connector.jar", "tomcat-users.xml"]
  }

  file { "tomcat-users.xml":
    owner => 'root',
    path => '/etc/tomcat/tomcat-users.xml',
    require => Package['tomcat'],
    notify => Service['tomcat'],
    content => template('/root/tomcat-users.xml.erb')
  }

  file { "mysql-connector.jar":
    require => Package['tomcat'],
    owner => 'root',
    path => '/usr/share/tomcat/lib/mysql-connector-java-5.1.34.jar',
    source => '/root/mysql-connector-java-5.1.34-bin.jar'
  }

}

$tomcat_password = 'deployer'
$tomcat_user = 'deployer'

include tomcat
include openjdk
