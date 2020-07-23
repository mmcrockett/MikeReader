set :deploy_to, File.join('', 'home', USER, 'reader.mmcrockett.com')

append :linked_files, 'config/credentials/production.key'
