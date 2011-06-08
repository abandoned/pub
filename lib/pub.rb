begin
  require "yajl"
rescue LoadError
  require "json"
end

require "redis"
require "redis/connection/synchrony"

require "pub/configuration"
require "pub/queue"
require "pub/version"

# A Redis-backed pub/sub messaging system for processing queues.
module Pub
  extend self

  # Returns the queue by the specified name.
  def [](name)
    Queue.new(name)
  end

  # Yields the configuration object to define application-wide settings.
  def configure
    yield configuration
  end

  # A Redis connection pool.
  def redis
    @redis ||=
      EM::Synchrony::ConnectionPool.new(size: configuration.pool_size) do
        Redis.new(configuration.connection_options)
      end
  end

  private

    def configuration
      @configuration ||= Configuration.new
    end
end
