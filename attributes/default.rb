default[:phpenv] = {
  :build_php_versions  => ["5.5.9"],
  :install_dir         => ENV['HOME'],
  :install_script      => "https://raw.githubusercontent.com/CHH/phpenv/master/bin/phpenv-install.sh",
  :install_user        => ENV['USER'],
  :install_user_home   => ENV['HOME'],
  :phpenv_root         => "#{ENV['HOME']}/.phpenv",
}
