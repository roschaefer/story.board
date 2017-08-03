Feature: Generate sensor data as JSON for frontend
  As a frontend designer
  I want data from a sensor I select via id as json - beginning at a time I specify via query, in intervals I can also specify via query in minutes, sorted from oldest to newest
  In order to easily integrate the data in my frontend.

  Background:
    Given we have these sensor readings for sensor 95 in our database:
      | Id    | Created at       | Calibrated value | Uncalibrated value | Release |
      | 24593 | 2017-07-18 15:09 | 39.701           | 39.701             | final   |
      | 24581 | 2017-07-18 14:39 | 39.369           | 39.369             | final   |
      | 24569 | 2017-07-18 14:09 | 39.459           | 39.459             | final   |
      | 24557 | 2017-07-18 13:39 | 39.248           | 39.248             | final   |
      | 24545 | 2017-07-18 13:09 | 38.382           | 38.382             | final   |
      | 24527 | 2017-07-18 12:19 | 39.008           | 39.008             | final   |
      | 24521 | 2017-07-18 12:09 | 39.068           | 39.068             | final   |
      | 24516 | 2017-07-18 11:59 | 39.188           | 39.188             | debug   |
      | 24497 | 2017-07-18 11:09 | 39.038           | 39.038             | final   |
      | 24588 | 2017-07-17 14:59 | 39.55            | 39.55              | final   |
      | 24587 | 2017-07-17 14:49 | 39.429           | 39.429             | final   |
      | 24576 | 2017-07-17 14:29 | 39.369           | 39.369             | final   |
      | 24575 | 2017-07-17 14:19 | 39.399           | 39.399             | final   |
      | 24564 | 2017-07-17 13:59 | 39.459           | 39.459             | final   |
      | 24563 | 2017-07-17 13:49 | 39.429           | 39.429             | final   |
      | 24552 | 2017-07-17 13:29 | 39.068           | 39.068             | final   |
      | 24551 | 2017-07-17 13:19 | 38.769           | 38.769             | final   |
      | 24540 | 2017-07-17 12:59 | 37.673           | 37.673             | final   |
      | 24539 | 2017-07-17 12:49 | 36.016           | 36.016             | final   |
      | 24533 | 2017-07-17 12:39 | 35.242           | 35.242             | final   |
      | 24528 | 2017-07-17 12:29 | 39.098           | 39.098             | final   |
      | 24515 | 2017-07-16 11:49 | 39.339           | 39.339             | final   |
      | 24509 | 2017-07-16 11:39 | 39.278           | 39.278             | final   |
      | 24491 | 2017-07-16 10:49 | 39.188           | 39.188             | final   |
      | 24485 | 2017-07-16 10:39 | 39.128           | 39.128             | final   |
      | 24479 | 2017-07-16 10:19 | 39.158           | 39.158             | final   |
      | 24473 | 2017-07-16 10:09 | 39.128           | 39.128             | final   |
      | 24504 | 2017-07-16 11:29 | 39.188           | 39.188             | final   |
      | 24503 | 2017-07-16 11:19 | 39.068           | 39.068             | final   |
      | 24467 | 2017-07-15 09:49 | 38.859           | 38.859             | final   |
      | 24461 | 2017-07-15 09:39 | 38.62            | 38.62              | final   |
      | 24456 | 2017-07-15 09:29 | 38.323           | 38.323             | final   |
      | 24455 | 2017-07-15 09:19 | 37.968           | 37.968             | final   |
      | 24443 | 2017-07-15 08:49 | 38.561           | 38.561             | final   |
      | 24437 | 2017-07-15 08:39 | 38.353           | 38.353             | final   |
      | 24419 | 2017-07-15 07:49 | 39.459           | 39.459             | final   |
      | 24413 | 2017-07-15 07:39 | 39.519           | 39.519             | final   |
      | 24408 | 2017-07-15 07:29 | 39.489           | 39.489             | final   |
      | 24407 | 2017-07-15 07:19 | 39.489           | 39.489             | final   |

  Scenario: Prepare sensor data (between 'since' and 'to') and send as json
    Given I send and accept JSON
    When I send a GET request to "reports/1/sensors/95/sensor_readings?from=2017.07.17%2014:40&to=2017.07.18%2012:19"
    Then the JSON response should be:
    """
    [
    {"id": 24527, "created_at": "2017-07-18T12:19:00.000Z", "calibrated_value": 39.008, "uncalibrated_value": 39.008, "release": "final" },
    {"id": 24521, "created_at": "2017-07-18T12:09:00.000Z", "calibrated_value": 39.068, "uncalibrated_value": 39.068, "release": "final" },
    {"id": 24516, "created_at": "2017-07-18T11:59:00.000Z", "calibrated_value": 39.188, "uncalibrated_value": 39.188, "release": "debug" },
    {"id": 24497, "created_at": "2017-07-18T11:09:00.000Z", "calibrated_value": 39.038, "uncalibrated_value": 39.038, "release": "final" },
    {"id": 24588, "created_at": "2017-07-17T14:59:00.000Z", "calibrated_value": 39.55 , "uncalibrated_value": 39.55 , "release": "final" },
    {"id": 24587, "created_at": "2017-07-17T14:49:00.000Z", "calibrated_value": 39.429, "uncalibrated_value": 39.429, "release": "final" }
    ]
    """
