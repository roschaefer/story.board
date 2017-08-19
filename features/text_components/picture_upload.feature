@547 @548 @557
Feature: Picture Upload
  As editor
  I want to have a picture upload for my amazon s3 with the text components
  in order to easyly integrate images and provide them for the frontend.

  @aws_s3_request
  Scenario: Upload picture
    Given I am the journalist
    When I edit an existing text component
    And in section Image I choose my file "testbild.png" for upload
    And I submit the form and upload the image
    Then a request to Amazon S3 is made with my chosen file
    And the text component starts with the url
    """
    /system/text_components/images/000/000/001/original/cow.jpg
    """
