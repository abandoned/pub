Feature: Timeout
  As a pub patron  
  I do not want to have to wait indefinitely at the counter
  Because I do not value late-served beer

  Background:
    Given 1 pub
    And 1 bartender
    And "John" will not wait over 1 seconds

  Scenario: Do not wait over a second
    Given a bartender serves 1 beer per second
    When "John" orders:
      | beer          |
      | Evented Lager |
      | Async Pilsen  |
      | Blocking Ale  |
    Then "John" should receive in 1 second:
      | beer                    |
      | A pint of Evented Lager |

  Scenario: Orders will persist for beers simultaneously ordered by other patrons
    Given a bartender serves 1 beer per second
    When "John" orders:
      | beer          |
      | Evented Lager |
      | Async Pilsen  |
      | Blocking Ale  |
    And "Jane" orders:
      | beer         |
      | Blocking Ale |
    Then "John" should receive his beer in 1 second
    And there should be a pending order for:
      | beer         |
      | Blocking Ale |
    And there should be no pending order for:
      | beer         |
      | Async Pilsen |
