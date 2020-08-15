USER='washingrvingrbenvrails'

lock '~> 3.14.1'

server 'mmcrockett.com', user: USER, roles: %w{app db web}

set :application, 'mikereader'
set :repo_url, 'git@github.com:mmcrockett/MikeReader.git'
set :rbenv_ruby_version, '2.7.1'
set :branch, ENV['BRANCH'] if ENV['BRANCH']
set :tmp_dir, File.join('', 'home', USER, 'tmp')
set :conditionally_migrate, true
set :keep_assets, 3

append :linked_dirs, 'log'
append :linked_dirs, 'tmp'
append :linked_dirs, File.join('public', 'packs')
append :linked_dirs, '.bundle'
append :linked_dirs, 'node_modules'

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  desc 'Run rake yarn install'
  task :yarn_install do
    on roles(:web) do
      within release_path do
        execute("cd #{release_path} && yarn install --silent --no-progress --no-audit --no-optional")
      end
    end
  end

  after :publishing, :restart
  before 'assets:precompile', :yarn_install
end
