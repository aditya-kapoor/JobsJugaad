require 'bundler/capistrano'
default_run_options[:pty] = true
set :user, "aditya"
set :use_sudo, false

server "50.19.196.143", :app, :web, :db, :primary => true

set :key_user, "Aditya"
ssh_options[:keys] = [File.join(ENV["HOME"], ".ec2", "#{key_user}")]

set :application, "JobsJugaad"

set :repository, "https://github.com/aditya-kapoor/JobsJugaad.git"
set :scm, "git"
set :branch, "master"
set :deploy_via, :remote_cache

set :deploy_to, "/var/www/apps/#{application}"

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do 
    run "/etc/init.d/apache2 start"
  end
  task :stop do 
    run "/etc/init.d/apache2 stop"
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

namespace :gems do 
  task :install do 
    # run "cp #{current_path}/config/database.yml #{release_path}/config/"
    run "mv #{current_path}/config/database.yml.example #{current_path}/config/database.yml"
    # run "cd #{current_path} && bundle exec rake assets:precompile"
  end
end

after :deploy, "gems:install"