module PubHelpers
  def data_store(name)
    patron_names << name unless patron_names.include?(name)

    instance_variable_get("@hash_of_#{name}") ||
    instance_variable_set("@hash_of_#{name}", Hash.new)
  end

  def find_or_create_patron(name)
    instance_variable_get("@#{name}") ||
    instance_variable_set("@#{name}", pub.new_patron)
  end

  def map_beers(table)
    table.hashes.map { |hash| hash["beer"] }
  end

  def now
    Time.now
  end

  def orders
    @orders ||= Hash.new
  end

  def patron_names
    @patron_names ||= []
  end

  def pub
    @pub ||= Pub.new("Ye Olde Rubies")
  end

  def sleep_until_order_complete(name)
    fiber = data_store(name)[:fiber]
    EM::Synchrony.sleep(0.1) while fiber.alive?
  end
end

World(PubHelpers)

Given /^(\d+) bartenders?$/ do |count|
  count.times do |counter|
    bartender = pub.new_bartender
    EM.add_periodic_timer(1) do
      Fiber.new do
        orders = bartender.take_orders(1)
        order = orders.first
        bartender.serve(order) { "A pint of #{order}" } if order
      end.resume
    end
  end
end

Given /^"([^"]+)" has no patience to wait more than (\d+) seconds at the counter$/ do |name, seconds|
  patron = find_or_create_patron(name)
  patron.instance_variable_set(:@timeout, seconds)
end

When /^"([^"]+)" orders:$/ do |name, table|
  beers  = map_beers(table)
  patron = find_or_create_patron(name)

  data_store(name)[:started_at] = Time.now

  fiber = Fiber.new do
    tray = patron.order(*beers)
    data_store(name)[:tray] = tray
  end
  data_store(name)[:fiber] = fiber

  EM.next_tick { fiber.resume }
end

When /^(\d+) patrons order (\d+) beers? each$/ do |patrons_count, beers_count|
  patrons_count.times do |patron_counter|
    raw = beers_count.times.inject("| beer |\n") do |raw, beer_counter|
      raw << "| beer_#{patron_counter}_#{beer_counter} |\n"
    end
    name = "patron_#{patron_counter}"
    When %{"#{name}" orders:}, table(raw)
  end
end

Then /^"([^"]+)" should receive (?:his|her) beers? in (\d+) seconds?$/ do |name, seconds|
  sleep_until_order_complete(name)

  started_at = data_store(name)[:started_at]
  (now - started_at).should be_within(0.2).of(seconds)
end

Then /^"([^"]+)" should receive the following beers? in (\d+) seconds?:$/ do |name, seconds, table|
  sleep_until_order_complete(name)

  started_at = data_store(name)[:started_at]
  (now - started_at).should be_within(0.2).of(seconds)

  beers = map_beers(table)
  tray = data_store(name)[:tray]
  tray.should =~ beers
end

Then /^they should receive their beers within (\d+) seconds?$/ do |seconds|
  started_at  = now
  patron_names.each do |name|
    patron_started_at = data_store(name)[:started_at]
    started_at = patron_started_at if patron_started_at < started_at
    sleep_until_order_complete(name)
  end

  (now - started_at).should be_within(0.2).of(seconds)
end
