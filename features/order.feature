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
    Then I should receive a knock on the shoulder in 1 second

  Scenario: Order multiple drinks
    Given 1 bartender
    When I order:
      | drink          |
      | Brooklyn Lager |
      | Efes Pilsen    |
    Then I should receive a knock on the shoulder in 2 seconds

  Scenario: Two bartenders
    Given 2 bartenders
    When I order:
      | drink          |
      | Brooklyn Lager |
      | Efes Pilsen    |
    Then I should receive a knock on the shoulder in 1 second
