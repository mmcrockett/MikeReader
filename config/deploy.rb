# config valid for current version and patch releases of Capistrano
lock '~> 3.14.1'

set :application, 'mikereader'
set :repo_url, 'git@github.com:mmcrockett/MikeReader.git'
set :rvm_ruby_version, '2.7.1'

append :linked_dirs, 'log'
append :linked_dirs, 'tmp'
append :linked_files, 'config/credentials/staging.key'

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart
end
