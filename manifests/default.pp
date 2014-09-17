Exec { 
  path => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"],
}

exec { "apt-get update":
}

package { "curl":
  require => Exec["apt-get update"],
}

exec { "get rvm":
  command => "curl -sSL https://get.rvm.io | bash -s stable --ruby=1.9.3",
  require => Package["curl"],
}

exec { "source rvm":
  command => "source ~/.rvm/scripts/rvm",
  require => Exec["get rvm"],
}

exec { "gem install bundler":
  require => Exec["source rvm"],
}

exec { "pushd /vagrant":
  command => "bash -c 'pushd /vagrant'",
}

exec { "bundle install":
  require => Exec["gem install bundler", "pushd /vagrant"],
}

exec { "bundle exec rake generate preview":
  require => Exec["bundle install"],
}
