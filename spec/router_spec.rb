require './status_checker'

describe StatusChecker::Router, '#send_request' do


  let(:port) { 3000 }
  let(:router) { StatusChecker::Server.router }

  before(:all) do
    Thread.new do
      EM::run do
        puts "Starting HTTP server on port #{port}"
        EM::start_server "0.0.0.0", port, StatusChecker::Server
      end  
    end
  end


  it 'sends 3 successful requests and 4 failed requests to specified URL' do
    success_url    = 'http://ya.ru'
    failure_url    = 'http://ya.asdf'

    3.times { make_request "/send?url=#{success_url}" }
    4.times { make_request "/send?url=#{failure_url}" }

    sleep 3

    success_request_count = router.watcher.to_hash[:successful_requests].reduce(:+)
    failed_request_count  = router.watcher.to_hash[:failed_requests].reduce(:+)

    expect(success_request_count).to be_equal(3)
    expect(failed_request_count).to be_equal(4)
  end


  describe '/send' do
    it 'respond with message for valid URL' do
      resp = make_request('/send?url=http://ya.ru')
      expect(resp).to eq('The request to URL http://ya.ru is sent and response is being processed')
    end

    it 'respond with error message for invalid URL' do
      resp = make_request('/send?url=asdf.asdf')
      expect(resp).to eq('The url asdf.asdf is of invalid format')
    end

    it 'respond with error message for empty URL' do
      resp = make_request('/send?url')
      expect(resp).to eq('The url param must be present')
    end
  end


  def make_request path
    Net::HTTP.get(URI.parse("http://0.0.0.0:3000#{path}"))
  end

end
