server '15.206.118.15', user: 'deploy', roles: [:web, :app, :db], primary: true

set :stage, :production
set :branch, 'main'
set :puma_env, 'production'
