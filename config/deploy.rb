# New Repo Steps:
#   gem install capistrano
#   capify .
#   cap deploy:setup
#   cap deploy:check
# Setup Webfaction
#   cd ~/webapps-releases/ehouseoffers/
#   mkdir -p shared/config
#     * might also need assets, certs, log
#   cd ~/webapps/ehouseoffers/
#   rm -rf hello_world/
#   emacs nginx/conf/nginx.conf
#     * replace 'hello_world' with 'webapp'
#   ln -sf /home/ehouseoffers/webapps-releases/ehouseoffers/current/ webapp
#   cd ~/webapps/ehouseoffers/
#   export GEM_HOME=$PWD/gems
#   export PATH=$PWD/bin:$PATH
#   gem install bundler
# Deploy App without bundle_install, then:
#   cd ~/webapps-releases/ehouseoffers/current/
#   bundle install
# Deploy App again with bundle_install

# Migrating old database
# 1. On old machine, dump and zip the database:
#   mysqldump -u<username> -p<password> --host=<host> <database name> |bzip2 -c > database.mysql.bz2
# 2. scp the file:
#   scp ./database.mysql.bz2 ehouseoffers@199.115.114.46:/home/ehouseoffers
# 3. populate the new database
#   bunzip2 < database.mysql.bz2 | mysql -u<username> -p<password> <database name>



default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :application, "ehouseoffers"
set :webfaction_username, "ehouseoffers"
set :webfaction_port, "25638"

set :webfaction_db_type, "mysql"
set :webfaction_db, "ehouseoffers"
set :webfaction_db_username, "ehouseoffers"

set :deploy_to, "/home/#{webfaction_username}/webapps-releases/#{application}"
 
set :scm, :git
set :scm_user, "ehouseoffers"
set :scm_verbose, true
set :repository, "git@github.com:ehouseoffers/Website.git"
 
set :user, "#{webfaction_username}"
set :use_sudo, false 
 
set :domain, "#{webfaction_username}.webfactional.com"
 
role :app, domain
role :web, domain
role :db,  domain, :primary => true
 
default_environment['PATH']='/home/ehouseoffers/webapps/git/bin:/home/ehouseoffers/webapps/ehouseoffers/bin:/home/ehouseoffers/bin:/usr/local/bin:/usr/local/mysql/bin:/opt/local/apache2/bin:/opt/local/bin:/Users/younker/.rvm/gems/ruby-1.8.7-p302/bin:/usr/kerberos/bin:/bin:/usr/bin'
default_environment['GEM_HOME']='/home/ehouseoffers/webapps/ehouseoffers/gems'

namespace :deploy do
  desc "Symlink all the /shared assets to their new version-specific path"
  task :my_symlink, :roles => :app do
    # release_path = /home/ehouseoffers/webapps-releases/ehouseoffers/releases/20110407164415
    # deploy_to    = /home/ehouseoffers/webapps-releases/ehouseoffers
    run "ln -nfs #{release_path} #{deploy_to}/current"
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/keys.yml #{release_path}/config/keys.yml"
    run "ln -nfs #{shared_path}/assets #{release_path}/public/"
    run "ln -nfs #{shared_path}/certs #{release_path}"
  end
  after "deploy:create_symlink", "deploy:my_symlink"


  desc "bundle install the necessary prerequisites"
  task :bundle_install, :roles => :app do
    run "cd #{deploy_to}/current/ && /home/ehouseoffers/webapps/#{application}/bin/bundle install"
  end
  after "deploy:my_symlink", "deploy:bundle_install"


  desc "Redefine deploy:restart"
  task :restart, :roles => :app do
    # deploy_to = /home/ehouseoffers/webapps-releases/ehouseoffers
    run "/home/#{webfaction_username}/webapps/#{application}/bin/restart"
  end


  desc "Stop delayed jobs"
  task :stop_delayed_jobs do
    run "#{deploy_to}/current/script/delayed_job stop"
  end
  after "deploy:restart", "deploy:stop_delayed_jobs"


  desc "Start delayed jobs"
  task :start_delayed_jobs do
    run "#{deploy_to}/current/script/delayed_job start"
  end
  after "deploy:restart", "deploy:start_delayed_jobs"


  ##
  ## Redefine Some Tasks
  ##
  desc "My webfaction specific deploy:start"
  task :start, :roles => :app do
    run "/home/#{webfaction_username}/webapps/#{application}/bin/start"
  end
 
  desc "My webfaction specific deploy:stop"
  task :stop, :roles => :app do
    run "/home/#{webfaction_username}/webapps/#{application}/bin/stop"
  end

end

