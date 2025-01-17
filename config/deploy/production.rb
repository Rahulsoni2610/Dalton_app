server '15.206.118.15', port: 22, roles: [:web, :app, :db], primary: true

set :stage, :production
set :branch, 'main'
set :repo_url, "git@github.com:Rahulsoni2610/Dalton_app.git"
set :puma_env, 'production'
