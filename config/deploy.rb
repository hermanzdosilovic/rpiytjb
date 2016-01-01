require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'

set :branch, 'master'
set :deploy_to, '/var/www/rpiytjb'
set :domain, 'gitac.ddns.net'
set :forward_agent, true
set :port, '22219'
set :rails_env, 'production'
set :repository, 'git@github.com:hermanzdosilovic/rpiytjb.git'
set :user, 'pi'

set :shared_paths, %w{.env log audio control}

task setup: :environment do
  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/log"]
  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/audio"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/audio"]
  queue! %[mkfifo "#{deploy_to}/#{shared_path}/control"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/audio"]
  queue! %[touch "#{deploy_to}/#{shared_path}/.env"]
end

desc "Deploys the current version to the server."
task deploy: :environment do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'deploy:cleanup'

    to :launch do
      queue "mkdir -p #{deploy_to}/#{current_path}/tmp/"
      queue "touch #{deploy_to}/#{current_path}/tmp/restart.txt"
    end
  end
end

task :environment do
    invoke :'rbenv:load'
end
