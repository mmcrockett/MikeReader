set :deploy_to, File.join('', 'home', USER, 'reader.test.mmcrockett.com')

append :linked_files, 'config/credentials/staging.key'

namespace :deploy do
  desc 'Setup passenger in htaccess'
  task :htaccess_config do
    on roles(:app), in: :sequence, wait: 5 do
      execute :echo, 'SetEnv RAILS_ENV staging', '>>', release_path.join('.htaccess')
    end
  end

  before :restart, :htaccess_config
end
