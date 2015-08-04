Feature: Add nameserver to domain
  In order to associate a domain with a nameserver
  As an administrator
  I must be able to add a nameserver to the domain

  Scenario: Add host
    Given I am authenticated as administrator
    When  I try to add a host
    Then  the host must be added to the domain