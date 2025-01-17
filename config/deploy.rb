# config valid for current version and patch releases of Capistrano
lock "~> 3.19.2"

set :keep_releases, 2

set :application, "dalton_app"
set :user,        'ubuntu'
set :puma_threads,    [4, 16]
set :puma_workers,    4

# Don't change these unless you know what you're doing
set :pty,             true
set :use_sudo,        true
# set :rvm_ruby_version, '3.0.0'


# set :asdf_custom_path, '~/.my_asdf_installation_path'
set :rbenv_type, :user # Use :user if rbenv is installed in the home directory
set :rbenv_ruby, '3.2.2' # Replace with the Ruby version you want to use
set :rbenv_path, '/home/ubuntu/.rbenv' # Path where rbenv is installed
set :rbenv_roles, :all # Default role to apply rbenv
set :deploy_to,       "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :ssh_options,     { forward_agent: true, user: fetch(:user) }
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to true if using ActiveRecord
set :puma_enable_socket_service, true
set :tmp_dir, "/home/#{fetch(:user)}/apps/#{fetch(:application)}/tmp"
append :linked_files, "config/database.yml", "config/puma.rb", "config/master.key"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle", "public/system", "public/packs", "node_modules", "client/node_modules"

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"

      Rake::Task['puma:start'].clear_actions
    end
  end
  before :start, :make_dirs
end

before 'deploy:starting', 'deploy:skip_assets'
before "deploy:assets:precompile", "deploy:yarn_install"
set :conditionally_migrate, true

namespace :deploy do
  desc 'Skip asset compile'
  task :skip_assets do
    puts Airbrussh::Colors.yellow('** Skipping asset compile.')
    Rake::Task["deploy:assets:backup_manifest"].clear_actions
    Rake::Task['deploy:assets:precompile'].clear_actions
    Rake::Task['deploy:migrating'].clear_actions
  end
end

# namespace :sidekiq do

#   task :restart do
#     invoke 'sidekiq:stop'
#     invoke 'sidekiq:start'
#   end

#   before 'deploy:finished', 'sidekiq:restart'

#   task :stop do
#     on roles(:app) do
#       within current_path do
#         execute('sudo service sidekiq stop')
#         # execute('sudo systemctl stop elasticsearch')
#       end
#     end
#   end

#   task :start do
#     on roles(:app) do
#       within current_path do
#         execute('sudo service sidekiq start')
#         # execute('sudo systemctl start elasticsearch')
#       end
#     end
#   end
# end

namespace :deploy do
  desc 'Run rake yarn:install'
  task :yarn_install do
    on roles(:web) do
      within release_path do
        # Compile assets
        # execute :bundle, 'exec rake assets:precompile --trace RAILS_ENV=production'
        # Run database migrations
        execute :bundle, 'exec rake db:migrate --trace RAILS_ENV=production'
      end
    end
  end
end

namespace :deploy do
  desc "Make sure local git is in sync with remote."

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start_echo'
      before 'assets:precompile', 'purge_css:clear'
      after 'assets:precompile', 'purge_css:run'
    end
  end

  after  :finishing,    :cleanup
  after  :finishing,    :restart
end
