default_run_options[:pty] = true
set :user, "aditya"
set :use_sudo, true

server "54.242.75.184", :app, :web, :db, :primary => true

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
    run "cd #{deploy_to}/current && RAILS_ENV=production #{try_sudo} bundle install"
    # run "echo '#{release_path}'"
    # run "cp #{current_path}/config/database.yml #{release_path}/config/"
    run "cd #{current_path} && RAILS_ENV=production bundle exec rake db:migrate"
  end
end

after :deploy, "gems:install"