server "mmcrockett.com", user: "washingrvingrails", roles: %w{app db web}

set :deploy_to, File.join("","home","washingrvingrails","reader.rvm.mmcrockett.com")
set :tmp_dir, File.join("","home","washingrvingrails","tmp")
