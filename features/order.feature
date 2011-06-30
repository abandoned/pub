Feature: Order drinks
  As a pub patron  
  I want bartenders to take orders asynchronously  
  So I do not block the counter  

  Below we assume a bartender can fill an order in one second.

  Scenario: Order a drink
    Given 1 bartender
    When I order:
      | drink          |
      | Brooklyn Lager |
    Then I should receive my drink in 1 second

  Scenario: Order multiple drinks
    Given 1 bartender
    When I order:
      | drink          |
      | Brooklyn Lager |
      | Efes Pilsen    |
    Then I should receive my drinks in 2 seconds

  Scenario: Two bartenders
    Given 2 bartenders
    When I order:
      | drink          |
      | Brooklyn Lager |
      | Efes Pilsen    |
    Then I should receive my drinks in 1 second

  Scenario: Timeout
    Given 1 bartender
    And I have no patience to wait more than 2 seconds at the counter
    When I order:
      | drink          |
      | Brooklyn Lager |
      | Efes Pilsen    |
      | Stella         |
    Then I should receive the following drinks in 2 seconds:
      | drink                    |
      | A pint of Brooklyn Lager |
      | A pint of Efes Pilsen    |
