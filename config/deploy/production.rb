# frozen_string_literal: true

# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:
require 'pry'
server '128.199.55.204', user: 'deployer', roles: %w[app db web], primary: true
set :rails_env, :production
set :sidekiq_config, -> { File.join(current_path, 'config', 'sidekiq.yml') }

# set :default_env, :env
# server "example.com", user: "deploy", roles: %w{app web}, other_property: :other_value
# server "db.example.com", user: "deploy", roles: %w{db}

# role-based syntax
# ==================

# Defines a role with one or multiple servers. The primary server in each
# group is considered to be the first unless any hosts have the primary
# property set. Specify the username and a domain or IP for the server.
# Don't use `:all`, it's a meta role.

# role :app, %w{deploy@example.com}, my_property: :my_value
# role :web, %w{user1@primary.com user2@additional.com}, other_property: :other_value
# role :db,  %w{deploy@example.com}

# Configuration
# =============
# You can set any configuration variable like in config/deploy.rb
# These variables are then only loaded and set in this stage.
# For available Capistrano configuration variables see the documentation page.
# http://capistranorb.com/documentation/getting-started/configuration/
# Feel free to add new variables to customise your setup.

# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult the Net::SSH documentation.
# http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start
#
# Global options
# --------------
set :ssh_options, {
  keys: %w[home/islam/.ssh/id_rsa],
  forward_agent: true,
  auth_methods: %w[publickey password],
  port: 2222
}
#
# The server-based syntax can be used to override options:
# ------------------------------------
# server "example.com",
#   user: "user_name",
#   roles: %w{web app},
#   ssh_options: {
#     user: "user_name", # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: "please use keys"
#   }
# before "git:check", "deploy:yarn_install"

# namespace :deploy do
#   desc 'Run rake yarn:install'
#   task :yarn_install do
#     on roles(:web) do
#       # within release_path do
#      # execute("which node >> /tmp/nodearn.txt ")
#      # execute("which nvm >> /tmp/nvm.txt ")
#      # execute("source ~/.zshrc && which yarn yarn >> /tmp/zsh.txt")
#      # execute("cd #{release_path} && /home/deployer/.nvm/versions/node/v14.10.1/bin/yarn install")
#      # execute("env >> /tmp/gachigasm.txt ")
#       execute("export NVM_DIR=/home/deployer/.nvm")
#       execute("echo $NVM_DIR >> /tmp/nvm_dir.txt")
#       #end
#   end
#  end
# end

# task :env do
#   on roles(:all) do
#     execute "env"
#   end
# end
