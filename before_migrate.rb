run "echo 'before_migrate.rb is running...'"
run "echo 'release_path: #{release_path}' >> #{shared_path}/logs.log"
run "ln -nfs #{shared_path}/config/foo.yml #{release_path}/config/foo.yml"
sudo "echo 'sudo works' >> /root/sudo.log"