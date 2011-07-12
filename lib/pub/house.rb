module Pub
  # A public house. Informally known as a pub.
  class House
    attr_reader :name

    def initialize(name)
      @name = "pub:#{name}"
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
    #
    # Yields the patron if a block is given. Patron will leave the counter
    # after ordering a single round.
    def new_patron(opts = {})
      patron = Patron.new(name, opts)

      if block_given?
        yield patron
        patron.leave
      else
        patron
      end
    end
  end
end
