set :application, "thelab"

server "votes.lab-cloud.net", :app

set :repository, ""
set :branch, "master"
set :scm, :git

set :user, "kevinprince"
set :group, "thelab"
set :use_sudo, false

set :deploy_to, "~/app"

set :deploy_via, :remote_cache
set :copy_exclude, [".git"]
set :git_enable_submodules, 1