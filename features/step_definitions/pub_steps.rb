module PubHelpers
  def orders
    @orders ||= Hash.new
  end

  def patron
    @patron ||= pub.new_patron
  end

  def pub
    @pub ||= Pub.new("Ye Olde Rubies")
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

Given /^I have no patience to wait more than (\d+) seconds at the counter$/ do |seconds|
  patron.instance_variable_set(:@timeout, seconds)
end

When /^I order:$/ do |table|
  drinks = table.hashes.map { |hash| hash["drink"] }

  @started_at = Time.now
  @tray       = patron.order(*drinks)
end

Then /^I should receive my drinks? in (\d+) seconds?$/ do |seconds|
  (Time.now - @started_at).should be_within(0.1).of(seconds)
end

Then /^I should receive the following drinks? in (\d+) seconds?:$/ do |seconds, table|
  (Time.now - @started_at).should be_within(0.1).of(seconds)
  drinks = table.hashes.map { |hash| hash["drink"] }
  @tray.should =~ drinks
end
