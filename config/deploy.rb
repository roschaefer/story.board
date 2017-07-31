require 'capistrano-db-tasks'


# config valid only for current version of Capistrano
lock '3.9.0'

set :application, 'story.board'
set :repo_url, 'https://github.com/roschaefer/story.board.git'
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/vicari/story.board'
set :db_dump_dir, -> { File.join(current_path, 'db', 'backups') }
set :disallow_pushing, true
set :db_local_clean, false

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  desc 'Runs rake db:seed'
  task seed: [:set_rails_env] do
    on primary fetch(:migration_role) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'db:seed'
        end
      end
    end
  end

  desc 'Restart Daemon'
  task :restart_daemon do
    on roles(:web)  do |host|
      execute :svc, '-du ~/service/story.board'
      info "Host #{host} restarting svc daemon"
    end
  end

  desc 'Reassign Ownership of Database Tables'
  task :reassign_db_ownership do
    on roles(:web) do |host|
      execute '~/reassign_db_ownership.sh', '-d story_board_production', '-o $POSTGRES_USERNAME'
      info "Host #{host} reassign ownership of all tables to postgres user"
    end
  end

  after :finished, :reassign_db_ownership
  after :finished, :restart_daemon
end
