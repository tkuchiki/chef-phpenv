# phpenv is required php-build.
# include_recipe "php-build" # (https://github.com/tkuchiki/chef-php-build)

install_dir       = node[:phpenv][:install_dir]
install_script    = node[:phpenv][:install_script]
install_user      = node[:phpenv][:install_user]
install_user_home = node[:phpenv][:install_user_home]
phpenv_root       = node[:phpenv][:phpenv_root]
bashrc            = "#{install_dir}/.bashrc"

bash "exec phpenv-install.sh" do
  user install_user
  code <<EOC
    curl -s #{install_script} | PHPENV_ROOT="#{phpenv_root}" sh
EOC

  not_if { File.exists?(phpenv_root) }
end

bash "setting PATH" do
  code <<EOC
    echo "export PATH=\"#{phpenv_root}/bin:$PATH\"" >> #{bashrc}
EOC

  not_if "grep \"#{phpenv_root}\" \"#{bashrc}\""
end

bash "setting eval $(phpenv init -)" do
  code <<EOC
    echo 'eval "$(phpenv init -)"' >> #{bashrc}
EOC

  not_if "grep \"phpenv init\" \"#{bashrc}\""
end

if node[:platform_family].include?("rhel")
  # require epel repo
  %w{gcc gcc-c++ make libxml2-devel libcurl-devel libjpeg-devel libpng-devel libmcrypt-devel libtidy-devel libxslt-devel readline-devel}.each do |pkg|
    package pkg
  end
end

node[:phpenv][:build_php_versions].each do |version|
  bash "build php #{version}" do
    code <<EOC
      php-build #{version} #{phpenv_root}/versions/#{version}
EOC

    not_if { File.exist?("#{phpenv_root}/versions/#{version}") }
  end
end
