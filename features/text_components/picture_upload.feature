@547 @548 @557
Feature: Picture Upload
  As editor
  I want to have a picture upload for my amazon s3 with the text components
  in order to easyly integrate images and provide them for the frontend.

  Scenario: Upload picture
    Given I am the journalist
    When I edit an existing text component
    And in section Image I choose my file "testbild.png" for upload
    And I submit the form and upload the image
    Then the text component image url starts with
    """
    /system/text_components/images/000/000/001/original/cow.jpg
    """

  Scenario: Delete picture
    Given I am the journalist
    When I edit an existing text component with an image
    And in section Image I tick the checkbox to delete the image
    And I submit the form and delete the image
    Then the text component image url is empty or shows the standard image missing url
