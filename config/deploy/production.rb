server "reader.mmcrockett.com", user: "washingrvingrails", roles: %w{app db web}

set :deploy_to, File.join("","home","washingrvingrails","reader.mmcrockett.com")
set :tmp_dir, File.join("","home","washingrvingrails","tmp")
