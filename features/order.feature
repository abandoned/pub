Feature: Order beers
  As a pub patron  
  I want bartenders to take orders asynchronously  
  So the counter is not blocked

  Scenario: Order a beer
    Given 1 pub
    And 1 bartender
    And a bartender serves 1 beer per second
    When "John" orders:
      | beer          |
      | Evented Lager |
    Then "John" should receive his beer in 1 second

  Scenario: Order multiple beers
    Given 1 pub
    And 1 bartender
    And a bartender serves 1 beer per second
    When "John" orders:
      | beer          |
      | Evented Lager |
      | Async Pilsen  |
    Then "John" should receive his beers in 2 seconds

  Scenario: Two bartenders
    Given 1 pub
    And 2 bartenders
    And a bartender serves 1 beer per second
    When "John" orders:
      | beer          |
      | Evented Lager |
      | Async Pilsen  |
    Then "John" should receive his beers in 1 second

  Scenario: Two patrons order the same beer
    Given 1 pub
    And 1 bartender
    And a bartender serves 1 beer per second
    When "John" orders:
      | beer          |
      | Evented Lager |
    And "Jane" orders:
      | beer          |
      | Evented Lager |
    Then "John" should receive his beer in 1 second
    And "Jane" should receive her beer in 1 second

  Scenario: Crowd
    Given 1 pub
    And 10 bartenders
    And a bartender serves 1 beer per second
    When 10 patrons order 1 beer each
    Then each should receive their beers within 1 second

  Scenario: Overcrowding
    Given 1 pub
    And 2 bartenders
    And a bartender serves 1 beer per second
    When 4 patrons order 2 beers each
    Then each should receive their beers within 4 seconds

  Scenario: Multiple pubs
    Given 10 pubs
    And each has 1 bartender
    And a bartender serves 1 beer per second
    When "John" orders in each pub:
      | beer          |
      | Evented Lager |
    Then "John" should receive his beers in 1 second

  Scenario: Able bartenders
    Given 10 pubs
    And each has 1 bartender
    And a bartender serves 2 beers per second
    When 2 patrons order 1 beer each
    Then each should receive their beers within 1 second
