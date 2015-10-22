lock '3.4.0'

set :application, 'test_ikit'
set :deploy_to, "/var/www/#{fetch(:application)}"
set :repo_url, 'git@github.com:valexl/test_kit.git'
set :linked_files, fetch(:linked_files, []).push('config/database.yml')
set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/uploads')
set :bundle_binstubs, -> { shared_path.join('bin') }
set :keep_releases, 3

namespace :deploy do
  %w[unicorn resque].each do |service|
    namespace service do
      %w[status up down restart 2].each do |command|
        desc "#{command.capitalize} #{service}"
        task command do
          on roles(:app) do
            execute "sudo sv #{command} #{fetch(:application)}_#{service}"
          end
        end
      end
    end
  end

  after :finished, 'unicorn:2'
  after :finished, 'resque:restart'
end