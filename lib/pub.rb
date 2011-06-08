begin
  require "yajl"
rescue LoadError
  require "json"
end

require "redis/connection/synchrony"
require "redis"

require "pub/version"

module Pub
  # Your code goes here...
end
