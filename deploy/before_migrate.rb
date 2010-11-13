run "echo 'before_migrate.rb is running...'"
run "echo 'node inspected: #{node.inspect}'"
run "echo 'release_path: #{release_path}'"
run "echo 'shared_path: #{shared_path}'"
run "echo 'current_path: #{current_path}'"

# run "ln -nfs #{shared_path}/config/foo.yml #{release_path}/config/foo.yml"
# sudo "echo 'sudo works' >> /root/sudo.log"