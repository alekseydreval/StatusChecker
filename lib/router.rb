class StatusChecker

  class Router

    attr_accessor :watcher

    STATS_TEMPLATE = './lib/templates/stats.rbhtml'


    def initialize
      puts 'Initializing router'
      @watcher = StatusChecker::Watcher.new
      @template_engine  = Tenjin::Engine.new
    end

    def dispatch req, &b
      $t = Time.now
      case req['path']
      when '/send'
        url = req['query'] && req['query']['url'] && req['query']['url'][0]
        unless url
          return b.call 200, 'The url param must be present'
        end
        send_request url, &b
      when '/stats'
        stats &b
      else
        b.call 404, 'The page is not found'        
      end
    end

    
    private

    # /stats
    def stats &b
      b.call 200, @template_engine.render(STATS_TEMPLATE, @watcher.to_hash)
    end

    # /send?url=<url>
    def send_request url, &b
      if Addressable::URI.parse(url).scheme
        b.call 200, "The request to URL #{url} is sent and response is being processed"
      else
        b.call 200, "The url #{url} is of invalid format"
        return
      end

      http = EventMachine::HttpRequest.new(url).get

      puts "Sending request to #{url}..."
      http.errback  { puts "Failed to request #{url}"; @watcher.request_failed }
      http.callback { puts "Succeeded to request #{url}"; @watcher.request_succeeded }
    end

  end

end
