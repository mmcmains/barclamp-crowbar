Feature: Support UI
  In order to support the Crowbar framework
  The system operator, Oscar
  wants to be able to do administration like export

  Scenario: Localization AJAX CN
    When I18N checks "chuck_norris"
    Then I should see "Die!!!"

  Scenario: Localization AJAX Hit
    When I18N checks "test.verify"
    Then I should see "Affirmative"

  Scenario: Localization AJAX Miss
    When I18N checks "test.miss"
    Then I get a {integer:404} error

  Scenario: Use the Log Marker
    When I go to the "utils/marker/foo" page
    Then I should see "foo"