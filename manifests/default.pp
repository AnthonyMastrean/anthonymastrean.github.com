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

exec { "gem install bundler":
  command => "bash -c 'source /usr/local/rvm/scripts/rvm; gem install bundler'",
  require => Exec["get rvm"],
}

exec { "bundle install":
  cwd => "/vagrant",
  command => "bash -c 'source /usr/local/rvm/scripts/rvm; bundle install'",
  require => Exec["gem install bundler"],
}

exec { "rake preview":
  cwd => "/vagrant",
  command => "bash -c 'source /usr/local/rvm/scripts/rvm; bundle exec rake generate'",
  require => Exec["bundle install"],
}
