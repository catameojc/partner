set :application, 'partner'
set :repo_url, 'https://github.com/catameojc/partner.git'
set :branch, ENV['REVISION'] || ENV['BRANCH'] || proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call
set :rails_env, 'production'

set :deploy_to, '/srv/partner'
set :log_level, :info
set :linked_files, %w{config/secrets.yml config/api.yml config/exception_notification.yml config/checkout.yml config/whois.yml config/paypal.yml config/paypal_redirect_urls.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/assets}

set :rbenv_path, '$HOME/.rbenv'
set :rbenv_type, :user
set :rbenv_ruby, proc { `cat .ruby-version`.chomp }.call
set :rbenv_map_bins, %w{rake gem bundle ruby rails unicorn}

set :bundle_jobs, 4
set :bundle_env_variables, { nokogiri_use_system_libraries: 1 }

set :assets_roles, [:web, :app]

after 'deploy:publishing', 'deploy:restart'

namespace :deploy do
  task :restart do
    invoke 'unicorn:restart'
  end
end

#namespace :deploy do
#  on roles :all do
#      execute :service, "unicorn upgrade"
#  end
#end
