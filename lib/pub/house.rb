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
    # Takes an optional value, in seconds, for the patron's patience, which
    # defaults to five seconds.
    def new_patron(patience = 5)
      Patron.new(name, patience)
    end
  end
end
