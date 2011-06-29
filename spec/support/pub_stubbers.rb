module PubStubbers
  def enter_pub
    Pub.new('Ye Olde Rubies') do |pub|
      yield pub
      pub.close
    end
  end

  def stub_orders(pub, *drinks)
    drinks.each do |drink|
      Pub.bar_counter.rpush(pub.name, drink)
    end
  end

  def stub_service(pub, *drinks)
    EM.add_timer(0.1) do
      Fiber.new do
        drinks.each do |drink|
          Pub.bar_counter.publish([pub.name, drink].join(':'), "A pint of #{drink}")
        end
      end.resume
    end
  end
end
