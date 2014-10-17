Exec { 
  path => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"],
}

include rvm

rvm::exec { "gem install bundler":
}

rvm::exec { "bundle install":
  cwd => "/vagrant",
  require => Rvm::Exec["gem install bundler"],
}

rvm::exec { "bundle exec rake generate":
  cwd => "/vagrant",
  require => Rvm::Exec["bundle install"],
}
