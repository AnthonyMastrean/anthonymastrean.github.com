class rvm::bundler() {

  include rvm

  rvm::exec { "gem install bundler":
  }

}
