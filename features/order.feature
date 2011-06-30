Feature: Order beers
  As a pub patron  
  I want bartenders to take orders asynchronously  
  So I do not block the counter  

  Below we assume a bartender can fill an order in one second.

  Scenario: Order a beer
    Given 1 bartender
    When "John" orders:
      | beer           |
      | Brooklyn Lager |
    Then "John" should receive his beer in 1 second

  Scenario: Order multiple beers
    Given 1 bartender
    When "John" orders:
      | beer           |
      | Brooklyn Lager |
      | Efes Pilsen    |
    Then "John" should receive his beers in 2 seconds

  Scenario: Two bartenders
    Given 2 bartenders
    When "John" orders:
      | beer           |
      | Brooklyn Lager |
      | Efes Pilsen    |
    Then "John" should receive his beers in 1 second

  Scenario: Timeout
    Given 1 bartender
    And "John" has no patience to wait more than 2 seconds at the counter
    When "John" orders:
      | beer           |
      | Brooklyn Lager |
      | Efes Pilsen    |
      | Stella         |
    Then "John" should receive the following beers in 2 seconds:
      | beer                     |
      | A pint of Brooklyn Lager |
      | A pint of Efes Pilsen    |

  Scenario: Two patrons order the same beer
    Given 1 bartender
    And "John" orders:
      | beer           |
      | Brooklyn Lager |
    And "Jane" orders:
      | beer           |
      | Brooklyn Lager |
    Then "John" should receive his beer in 1 second
    And "Jane" should receive her beer in 1 second

  Scenario: Crowd
    Given 10 bartenders
    When 10 patrons order 1 beer each
    Then they should receive their beers within 1 second

  Scenario: Overcrowding
    Given 2 bartenders
    When 4 patrons order 2 beers each
    Then they should receive their beers within 4 seconds
