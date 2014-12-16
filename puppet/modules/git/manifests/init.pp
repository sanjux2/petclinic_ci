class git {
  package { "git":
    allow_virtual => false,
    ensure => installed,
  }
}

include git
