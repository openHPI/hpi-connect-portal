# config valid only for Capistrano 3.1
lock '3.1.0'

# server variables
set :application, "hpi-career"
set :deploy_via, :remote_cache
set :use_sudo, false

# repository variables
set :scm, "git"
set :repo_url, "git@github.com:hpi-swt2/hpi-hiwi-portal.git"

# deployment variables
set :keep_releases, 5

# files we want symlinking to specific entries in shared.
set :linked_files, %w{config/database.yml}

# dirs we want symlinking to shared
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# config files that should be copied by deploy:setup_config
set(:config_files, %w(
  nginx.conf
  unicorn.rb
  unicorn_init.sh
))

# config files that should be made executable by deploy:setup_config
set(:executable_config_files, %w(
  unicorn_init.sh
))

namespace :deploy do

  # make sure we're deploying what we think we're deploying
  before :deploy, "deploy:check_revision"

  # only allow a deploy with passing tests to deployed
  # before :deploy, "deploy:run_tests"

  # compile assets locally then rsync
  after 'deploy:symlink:shared', 'deploy:compile_assets_locally'
  after :finishing, 'deploy:cleanup'

  # remove the default nginx configuration as it will tend
  # to conflict with our configs.
  before 'deploy:setup_config', 'nginx:remove_default_vhost'

  # reload nginx to it will pick up any modified vhosts from
  # setup_config
  after 'deploy:setup_config', 'nginx:reload'

  # As of Capistrano 3.1, the `deploy:restart` task is not called
  # automatically.
  after 'deploy:publishing', 'deploy:restart'
end
