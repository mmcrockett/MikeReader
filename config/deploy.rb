USER='washingrvingrbenvrails'

lock '~> 3.14.1'

server 'mmcrockett.com', user: USER, roles: %w{app db web}

set :application, 'mikereader'
set :repo_url, 'git@github.com:mmcrockett/MikeReader.git'
set :rbenv_ruby_version, '2.7.1'
set :branch, ENV['BRANCH'] if ENV['BRANCH']
set :tmp_dir, File.join('', 'home', USER, 'tmp')

append :linked_dirs, 'log'
append :linked_dirs, 'tmp'

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart
end
