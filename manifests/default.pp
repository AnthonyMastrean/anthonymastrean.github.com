package { ["make", "curl", "git", "ruby"]:
  ensure => present,
}

exec { "rvm":
  path => ["/usr/bin","/bin"],
  command => "curl -sSL https://get.rvm.io | bash -s stable --ruby=1.9.3 && source ~/.rvm/scripts/rvm",
  require => Package["curl"],
}

exec { "gem install bundler":
  path => ["/usr/bin","/bin"],
  require => Exec["rvm"],
}
