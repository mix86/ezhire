# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'ezhire'
set :repo_url, 'git@github.com:mix86/ezhire.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/core/ezhire'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :info

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 20

desc 'Bootstrap'
task :bootstrap do
  on roles(:app), in: :sequence, wait: 5 do
    execute "#{release_path}/bootstrap.sh"
  end
end

namespace :deploy do
  desc 'Start application'
  task :start do
    on roles(:app), in: :sequence, wait: 5 do
      execute :docker, :start, 'ez-mongo0'
      execute :docker, :start, 'ez-app0'
      execute :docker, :start, 'ez-ngx0'
    end
  end

  desc 'Stop application'
  task :stop do
    on roles(:app), in: :sequence, wait: 5 do
      execute :docker, :stop, 'ez-ngx0'
      execute :docker, :stop, 'ez-app0'
      execute :docker, :stop, 'ez-mongo0'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :docker, :restart, 'ez-mongo0'
      execute :docker, :restart, 'ez-app0'
      execute :docker, :restart, 'ez-ngx0'
    end
  end

  desc 'Compile assets'
  task :compile_assets do
    invoke 'deploy:assets:precompile_local'
  end

  namespace :assets do
    desc "Precompile assets locally and then rsync to web servers"
    task :precompile_local do
      # compile assets locally
      run_locally do
        execute "bundle exec rake assets:precompile"
        # execute "RAILS_ENV=#{fetch(:stage)} bundle exec rake assets:precompile"
      end

      # copy to each server
      local_dir = "./public/assets/"
      on roles( fetch(:assets_roles, [:web]) ) do
        # this needs to be done outside run_locally in order for host to exist
        remote_dir = "#{host.user}@#{host.hostname}:#{release_path}/public/"

        if fetch(:ssh_options)
          port = fetch(:ssh_options)[:port] || 22
          scp_options = "-r -P #{port}"

          keyfile = fetch(:ssh_options)[:keys].first

          if keyfile
            scp_options = "#{scp_options} -i #{keyfile}"
          end
        else
          scp_options = "-r"
        end

        run_locally do
          execute "scp #{scp_options} #{local_dir} #{remote_dir}"
        end
      end

      # clean up
      run_locally { execute "rm -rf #{local_dir}" }
    end
  end

  after :publishing, :compile_assets
  after :publishing, :restart
end
