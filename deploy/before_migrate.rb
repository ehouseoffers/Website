run "echo 'before_migrate.rb is running...'"
run "echo 'node inspected: #{node.inspect}' >> #{shared_path}/logs.log"
run "echo 'release_path: #{release_path}' >> #{shared_path}/logs.log"
run "echo 'shared_path: #{shared_path}' >> #{shared_path}/logs.log"
run "echo 'current_path: #{current_path}' >> #{shared_path}/logs.log"

# run "ln -nfs #{shared_path}/config/foo.yml #{release_path}/config/foo.yml"
# sudo "echo 'sudo works' >> /root/sudo.log"