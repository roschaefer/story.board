@438
Feature: GET recent entries
  As a frontend designer
  I want to send a GET request and get all diary entries along a time line
  In order to navigate between moments when the text of the diary has changed

  Background:
    Given we have these diary entries in our database:
      | Id | Moment           | Intention | Report id |
      | 1  | 2017-06-20 11:00 | fake      | 4711         |
      | 2  | 2017-06-21 14:00 | real      | 4711         |
      | 3  | 2017-06-22 10:00 | fake      | 4711         |
      | 4  | 2017-06-23 12:00 | real      | 4711         |
      | 5  | 2017-06-24 18:00 | fake      | 4711         |
    And I send and accept JSON

  Scenario: Without query parameter, return all diary entries
    When I send a GET request to "/reports/4711/diary_entries"
    Then the JSON response should be:
    """
    [
      {"id":1, "moment":"2017-06-20T11:00:00.000Z", "intention":"fake", "url":"http://example.org/reports/4711/diary_entries/1.json"},
      {"id":2, "moment":"2017-06-21T14:00:00.000Z", "intention":"real", "url":"http://example.org/reports/4711/diary_entries/2.json"},
      {"id":3, "moment":"2017-06-22T10:00:00.000Z", "intention":"fake", "url":"http://example.org/reports/4711/diary_entries/3.json"},
      {"id":4, "moment":"2017-06-23T12:00:00.000Z", "intention":"real", "url":"http://example.org/reports/4711/diary_entries/4.json"},
      {"id":5, "moment":"2017-06-24T18:00:00.000Z", "intention":"fake", "url":"http://example.org/reports/4711/diary_entries/5.json"}
    ]
    """

  Scenario: Get those diary entries that belong to the final sensorstory
    When I send a GET request to "/reports/4711/diary_entries?intention=real"
    Then the JSON response should include the diary entries 2 and 4

  Scenario: Get all diary entries within a certain timeframe
    When I send a GET request to "/reports/4711/diary_entries?from=2017-06-22T00:00:00&to=2017-06-24T00:00:00"
    Then the JSON response should include the diary entries 3 and 4

