module PubHelpers
  def activity(name)
    patron_names << name unless patron_names.include?(name)
    instance_variable_get("@activity_of_#{name}") || instance_variable_set("@activity_of_#{name}", Hash.new)
  end

  def bartenders
    @bartenders ||= Array.new
  end

  def find_or_create_patron(pub, name)
    key = "#{pub.name.gsub(/\W/, '')}#{name}"
    instance_variable_get("@#{key}") ||
    instance_variable_set("@#{key}", pub.new_patron)
  end

  def map_beers(table)
    table.hashes.map { |hash| hash["beer"] }
  end

  def now
    Time.now
  end

  def patron_names
    @patron_names ||= Array.new
  end

  def pubs
    @pubs ||= Array.new
  end

  def sleep_until_order_complete(name)
    activity(name).each do |pub_name, order|
      fiber = order[:fiber]
      EM::Synchrony.sleep(0.1) while fiber.alive?
    end
  end

  def tolerance
    0.2
  end
end

World(PubHelpers)

Given /^(\d+) pubs?$/ do |count|
  count.times do |counter|
    pubs << Pub.enter("Ye Rubies #{counter}")
  end
end

Given /^(?:each has )?(\d+) bartenders?$/ do |count|
  count.times do |counter|
    pubs.each do |pub|
      bartenders << pub.new_bartender
    end
  end
end

Given /^a bartender serves (\d+) beers? per second$/ do |count|
  bartenders.each do |bartender|
    EM.add_periodic_timer(1) do
      Fiber.new do
        bartender.take_orders(count).each do |order|
          bartender.serve(order) { "A pint of #{order}" }
        end
      end.resume
    end
  end
end


Given /^"([^"]+)" will not wait over (\d+) seconds$/ do |name, seconds|
  pubs.each do |pub|
    patron = find_or_create_patron(pub, name)
    patron.timeout = seconds
  end
end

When /^"([^"]+)" orders(?: in each pub)?:$/ do |name, table|
  beers  = map_beers(table)
  pubs.each do |pub|
    pub_activity = {:started_at => now }

    fiber = Fiber.new do
      patron = find_or_create_patron(pub, name)
      tray = patron.order(*beers)
      pub_activity[:tray] = tray
    end
    pub_activity[:fiber] = fiber

    activity(name)[pub.name] = pub_activity

    EM.next_tick { fiber.resume }
  end
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
  @pubs.each do |pub|
    sleep_until_order_complete(name)

    activity(name).each do |pub_name, order_activity|
      started_at = order_activity[:started_at]
      (now - started_at).should be_within(tolerance).of(seconds)
    end
  end
end

Then /^each should receive their beers? within (\d+) seconds?$/ do |seconds|
  started_at  = now
  patron_names.each do |name|
    activity(name).each do |pub_name, order_activity|
      patron_started_at = order_activity[:started_at]
      started_at = patron_started_at if patron_started_at < started_at
      sleep_until_order_complete(name)
    end
  end

  (now - started_at).should be_within(tolerance).of(seconds)
  
  patron_names.each do |name|
    Then %{"#{name}" should receive his beers in #{seconds} seconds}
  end
end

Then /^"([^"]+)" should receive the following beers? in (\d+) seconds?:$/ do |name, seconds, table|
  sleep_until_order_complete(name)

  activity(name).each do |pub_name, order_activity|
    started_at = order_activity[:started_at]
    (now - started_at).should be_within(tolerance).of(seconds)

    beers = map_beers(table)
    tray = order_activity[:tray]
    tray.should =~ beers
  end
end
