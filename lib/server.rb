class StatusChecker

  class Server < EM::HttpServer::Server

    def self.router
      @router ||= StatusChecker::Router.new
    end

    def process_http_request
      request = {}
      request['path']  = @http_request_uri
      request['query'] = CGI::parse(@http_query_string) if @http_query_string

      self.class.router.dispatch request do |status, content|
        response = EM::DelegatedHttpResponse.new(self)
        response.status = status
        response.content_type 'text/html'
        response.content = content
        response.send_response
      end
    end

    def http_request_errback err
      puts err
    end
    
  end

end
