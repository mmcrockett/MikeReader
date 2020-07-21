# config valid only for current version of Capistrano
lock '3.14.1'

set :application, 'mikereader'
set :repo_url, 'git@github.com:mmcrockett/MikeReader.git'
set :branch, ENV['BRANCH'] if ENV['BRANCH']

append :linked_dirs, "log"
append :linked_dirs, "tmp"

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart
end
