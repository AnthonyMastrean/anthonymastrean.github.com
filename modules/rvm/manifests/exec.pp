define rvm::exec(
  $command = $title,
  $cwd = undef,
) {

  include rvm

  exec { "rvm ${command}":
    cwd => $cwd,
    command => "bash -c 'source /usr/local/rvm/scripts/rvm; ${command}'",
  }

}
