class StatusChecker

  class Watcher

    attr_accessor :stats

    TIMESPAN       = 10
    TIME_INTERVAL  = 1


    def initialize
      @failed_requests     = 0
      @successful_requests = 0
      @stats = []
      watch
    end

    def request_succeeded
      @successful_requests += 1
    end

    def request_failed
      @failed_requests += 1
    end

    def to_hash
      fields = {}

      [:timestamp, :total_requests, :successful_requests, :failed_requests].each do |f|
        fields[f] = @stats.map{ |s| s[f] }
      end

      fields
    end


    private

    def watch
      Thread.new do
        loop {
          f, s = @failed_requests, @successful_requests
          @failed_requests = @successful_requests = 0

          # puts "Failed: #{f}; Succeed: #{s}"

          stat = {}
          stat[:failed_requests] = f
          stat[:successful_requests] = s
          stat[:total_requests] = stat[:failed_requests] + stat[:successful_requests]
          stat[:timestamp] = Time.now.strftime("%S")

          @stats.push stat

          if @stats.length > TIMESPAN
            @stats.shift
          end

          sleep TIME_INTERVAL
         }
      end
    end

  end
end
