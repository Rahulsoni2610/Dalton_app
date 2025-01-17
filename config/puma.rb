prequire 'puma/daemon'
# Change the binding to use only a UNIX socket
bind 'unix:///home/ubuntu/apps/dalton_app/shared/tmp/sockets/dalton_app-puma.sock'

# Optional: remove the TCP binding if it exists
# Uncomment this if you had TCP binding before:
# bind 'tcp://0.0.0.0:3000'

# Other settings, like threads, workers, etc.
threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_count, threads_count

# Specify the environment
preload_app!

# On worker boot
on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end

daemonize
