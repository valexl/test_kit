APP_PATH = File.expand_path('../../', __FILE__)

working_directory APP_PATH
listen            APP_PATH + '/tmp/sockets/unicorn.sock'
pid               APP_PATH + '/tmp/pids/unicorn.pid'
worker_processes  2
timeout           30
preload_app       true

before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = APP_PATH + '/Gemfile'
end

before_fork do |server, worker|
  ActiveRecord::Base.connection.disconnect! if defined?(ActiveRecord::Base)
  Resque.redis.quit if defined?(Resque)

  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill('QUIT', File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end

  sleep 1
end

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord::Base)
  Resque.redis = 'localhost:6379' if defined?(Resque)
end