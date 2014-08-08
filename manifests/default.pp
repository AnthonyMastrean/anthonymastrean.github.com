Exec { 
  path => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"],
}

package { ["make", "curl", "git", "ruby"]:
  ensure => present,
}

exec { "rvm":
  command => "curl -sSL https://get.rvm.io | bash -s stable --ruby=1.9.3 && source ~/.rvm/scripts/rvm",
  require => Package["curl"],
}

exec { "gem install bundler":
  require => Exec["rvm"],
}
