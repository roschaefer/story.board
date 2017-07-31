@316
Feature: Only published text components should be used to generate a report
  As a reporter
  I want save notes for every text component
  To provide, for example, information on our sources to our fact checkers

  Background:
    Given I am the journalist
  
  @javascript
  Scenario:
    Given we have a text component called "Bertold Brecht: Kuh beim Fressen":
    """
    Sie wiegt die breite Brust an holziger Krippe
    und frisst. Seht, sie zermalmt ein Hälmchen jetzt!
    Es schaut noch eine Zeitlang spitz aus ihrer Lippe
    sie malmt es sorgsam, dass sie’s nicht zerfetzt.

    Ihr Leib ist dick, ihr trauriges Aug bejahrt;
    gewöhnt des Bösen, zaudert sie beim Kauen
    seit Jahren mit emporgezognen Brauen - 
    die wundert´s nicht, wenn ihr dazwischenfahrt!

    Und während sie sich noch mit Heu versieht
    entzieht ihr einer Milch. Sie duldet stumm
    dass eine Hand an ihrem Euter reißt:

    Sie kennt die Hand. Sie schaut nicht einmal um.
    Sie wíll nicht wissen, was mit ihr geschieht
    und nützt die Abendstimmung aus und scheißt.
    """
    And I edit this text component
    And I take some notes for this text component:
    """
    Erschienen in den Augsburger Sonetten
    """
    And I click on "Update Text component"
    Then I should see in section "General Information":
    """
    Erschienen in den Augsburger Sonetten
    """
