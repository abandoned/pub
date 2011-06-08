Jotting down the idea:

# Configure

    Pub.redis = "localhost:6379"
    Pub.expires_in = 900

# Subscriber: A request

    Pub["foo"].subscribe("1234") do |resp|
      puts resp
    end

# Publisher: A background worker

    queue = Pub["foo"]
    # Process up to 10 requests at a time
    reqs = queue.pop(10)
    process(reqs) do |req, resp|
      queue.publish(req, resp)
    end
