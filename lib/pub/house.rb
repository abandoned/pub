module Pub
  class House
    # The name of the pub.
    attr_reader :name

    def initialize(name)
      @name = name
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
