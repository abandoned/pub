class Pub
  # Methods used by various classes in Pub.
  module Helpers
    class DecodeException < StandardError; end

    # Given a Ruby object, returns a string suitable for passing on to Redis.
    def encode(object)
      if defined? Yajl
        Yajl::Encoder.encode(object)
      else
        object.to_json
      end
    end

    # Given a string, returns a Ruby object.
    def decode(object)
      return unless object

      if defined? Yajl
        begin
          Yajl::Parser.parse(object, :check_utf8 => false)
        rescue Yajl::ParseError => e
          raise DecodeException, e
        end
      else
        begin
          JSON.parse(object)
        rescue JSON::ParserError => e
          raise DecodeException, e
        end
      end
    end
  end
end
