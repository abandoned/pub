module Pub
  # A public house. Informally known as a pub.
  class House
    attr_reader :name

    def initialize(name)
      @name = "pub:#{name}"
      EM.synchrony { yield self } if block_given?
    end

    # Closes the pub for the night.
    def close
      EM.stop
    end

    # A new bartender.
    def new_bartender
      Bartender.new(name)
    end

    # A new patron.
    #
    # Takes an optional hash of options to pass to the new patron instance.
    def new_patron(opts = {})
      Patron.new(name, opts)
    end
  end
end
