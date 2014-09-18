Exec { 
  path => ["/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/"],
}

include rvm
include rvm::bundler

rvm::exec { "bundle install":
  cwd => "/vagrant",
}

rvm::exec { "bundle exec rake generate":
  cwd => "/vagrant",
  require => Rvm::Exec["bundle install"],
}
