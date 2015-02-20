Exec { 
  path      => ['/bin', '/usr/bin', '/usr/local/bin'],
  logoutput => on_failure,
}

Exec['apt-get update'] -> Package <| |>
Package <| provider != gem |> -> Package['bundler']

exec { 'apt-get update': }

package { 'ruby':
  ensure => purged,
}

package { [
  'build-essential',
  'ruby1.9.1',
  'ruby1.9.1-dev',
  'rubygems1.9.1',
]:
  ensure  => latest,
  require => Package['ruby'],
}

file { '/etc/gemrc':
  ensure  => present,
  content => 'gem: --no-ri --no-rdoc'
}

package { 'bundler':
  ensure   => latest,
  provider => gem,
  require  => File['/etc/gemrc'],
}

exec { 'bundle install':
  cwd     => '/vagrant',
  require => Package['bundler'],
}

exec { 'bundle exec rake generate':
  cwd     => '/vagrant',
  require => Exec['bundle install'],
}
