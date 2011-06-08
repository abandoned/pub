module Pub
  # A configuration object for application-wide settings.
  class Configuration
    DEFAULT_EXPIRES_IN = 1500 # 30 minutes 
    DEFAULT_POOL_SIZE  = 10
    DEFAULT_REDIS_URL  = "redis://127.0.0.1:6379/0"

    # The connection pool size.
    attr_accessor :pool_size

    # The Redis URL.
    attr_accessor :redis_url

    # The period of time, in seconds, after which to expire a cached response.
    attr_accessor :expires_in

    def initialize
      self.expires_in = DEFAULT_EXPIRES_IN
      self.pool_size  = DEFAULT_POOL_SIZE
      self.redis_url  = DEFAULT_REDIS_URL
    end

    def connection_options
      url = URI(redis_url)

      { host:     url.host,
        port:     url.port,
        password: url.password,
        db:       url.path[1..-1].to_i }
    end
  end
end
