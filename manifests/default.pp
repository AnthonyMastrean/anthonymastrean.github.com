exec { "apt-get update":
  path => ["/usr/bin"],
}

package { ["make", "curl", "git", "ruby"]:
  ensure => present,
  require => Exec["apt-get update"],
}

exec { "rvm":
  path => ["/usr/bin"],
  command => "curl -sSL https://get.rvm.io | bash -s stable",
  unless => "which rvm",
  require => Package["curl"],
}

exec { "rvm install 1.9.3":
  path => ["/usr/bin"],
  require => Exec["rvm"],
}

exec { "rvm use 1.9.3":
  path => ["/usr/bin"],
  require => Exec["rvm install 1.9.3"],
}

exec { "rvm rubygems latest":
  path => ["/usr/bin"],
  require => Exec["rvm use 1.9.3"],
}

exec { "gem install bundler":
  path => ["/usr/bin"],
  require => Exec["rvm rubygems latest"],
}
