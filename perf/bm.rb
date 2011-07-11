NUMBER_OF_WORKERS = 1
REQUEST_CONCURRENCY = 5

require "rubygems"
require "bundler/setup"

require File.expand_path("../../lib/pub", __FILE__)

def now
  Time.now.to_i
end

queues = (1..6).map { |count| Pub.enter(count) }
batch  = 20.times.map { "1234567890" }
data   = "foobar"

EM.synchrony { Pub.counter.flushall; EM.stop }

pids = []
started_at = now

NUMBER_OF_WORKERS.times do
  queues.each do |queue|
    pids << Process.fork do
      EM.synchrony do
        worker = queue.new_bartender
        loop do
          jobs = worker.take_orders(20)
          EM::Synchrony.sleep(1) # simulate expense
          jobs.each { |job| worker.serve(job) { data } }
        end
      end
    end
  end

  at_exit do
    Process.kill("SIGTERM", *pids)
  end

  counter = 0
  EM.synchrony do
    loop do
      EM::Synchrony.sleep(0.5)
      REQUEST_CONCURRENCY.times do
        queues.each do |queue|
          fiber = Fiber.new do
            queue.new_patron do |consumer|
              consumer.order(*batch)
              counter += 1
              if counter % 100 == 0
                duration = now - started_at
                puts (counter / duration)
              end
            end
          end.resume
        end
      end
    end
  end
end
