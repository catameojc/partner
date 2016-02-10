Feature: Register a domain
  In order to register a domain
  As a partner
  I must be able to place an order for a domain

  @wip
  Scenario: Register Domain Completion
    Given I am authenticated as partner
    And the domain "domain.ph" does not exist
    When I try to register "domain.ph"
    Then it should create a new order

  @wip
  Scenario: Register Existing Domain
    Given I am authenticated as partner
    And the domain "domain.ph" exists
    When I try to register "domain.ph"
    Then I should get a message saying "already exists"
