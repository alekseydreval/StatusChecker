$LOAD_PATH << '.'

require 'bundler/setup' 

require 'pry'
require 'eventmachine'
require 'em-http-server'
require 'em-http-request'
require 'tenjin'


require 'lib/server'
require 'lib/router'
require 'lib/watcher'


# Only run the following code when this file is the main file being run
# instead of having been required or loaded by another file
if __FILE__ == $0
  EM::run do
    port = 3000
    puts "Starting HTTP server on port #{port}"
    EM::start_server "0.0.0.0", port, StatusChecker::Server
  end
end
