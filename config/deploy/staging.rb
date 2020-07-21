server "reader.test.mmcrockett.com", user: "washingrvingrbenvrails", roles: %w{app db web}

set :deploy_to, File.join("","home","washingrvingrbenvrails","reader.test.mmcrockett.com")
set :tmp_dir, File.join("","home","washingrvingrbenvrails","tmp")
