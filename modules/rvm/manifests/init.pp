class rvm() {

  package { "curl":
  }

  exec { "curl get.rvm.io":
    command => "curl -sSL https://get.rvm.io | bash -s stable --ruby=1.9.3",
    require => Package["curl"],
  }

}
