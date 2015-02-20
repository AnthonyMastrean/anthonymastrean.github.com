Exec { 
  path      => ['/bin', '/usr/bin', '/usr/local/bin'],
  logoutput => on_failure,
}

Exec['apt-get update'] -> Package <| |>

exec { 'apt-get update': }

Package <| provider != gem |> -> Package['bundler']

package { 'ruby':
  ensure => purged,
}

package { [
  'build-essential',
  'git',
  'ruby1.9.1',
  'ruby1.9.1-dev',
  'rubygems1.9.1',
]:
  ensure  => latest,
  require => Package['ruby'],
}

package { 'bundler':
  ensure   => latest,
  provider => gem,
  require  => File['/etc/gemrc'],
}

file { '/etc/gemrc':
  ensure  => present,
  content => 'gem: --no-ri --no-rdoc'
}

exec { 'bundle install':
  cwd     => '/vagrant',
  require => Package['bundler'],
}

exec { 'bundle exec rake generate':
  cwd     => '/vagrant',
  require => Exec['bundle install'],
}
