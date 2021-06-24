@systemtags-app-required @issue-ocis-reva-51
Feature: Creation of tags for the files and folders
  As a user
  I want to create tags for the files/folders
  So that I can find them easily

  Background:
    Given these users have been created with default attributes and without skeleton files:
      | username |
      | Alice    |
      | Brian    |
    And the user has browsed to the login page
    And user "Alice" has logged in using the webUI

  @issue-5017
  Scenario: Create a new tag that does not exist for a file in the root
    Given user "Alice" has uploaded file "lorem.txt" to "lorem.txt"
    When the user browses directly to display the details of file "lorem.txt" in folder "/"
    And the user adds a tag "Top Secret" to the file using the webUI
    And the user adds a tag "Confidential" to the file using the webUI
    Then file "/lorem.txt" should have the following tags for user "Alice"
      | Top Secret   | normal |
      | Confidential | normal |

  @issue-5017
  Scenario: Create a new tag that does not exist for a file in a folder
    Given user "Alice" has created folder "simple-folder"
    And user "Alice" has uploaded file "lorem.txt" to "simple-folder/lorem.txt"
    When the user browses directly to display the details of file "lorem.txt" in folder "simple-folder"
    And the user adds a tag "Top Secret" to the file using the webUI
    And the user adds a tag "Top" to the file using the webUI
    Then file "simple-folder/lorem.txt" should have the following tags for user "Alice"
      | Top Secret | normal |
      | Top        | normal |

  @issue-5017
  Scenario: Add a new tag that already exists for a file in a folder
    Given user "Alice" has created folder "simple-folder"
    And user "Alice" has uploaded file "lorem.txt" to "simple-folder/lorem.txt"
    And user "Alice" has uploaded file "lorem-big.txt" to "simple-folder/lorem-big.txt"
    And the user has browsed directly to display the details of file "lorem.txt" in folder "simple-folder"
    And the user has added a tag "lorem" to the file using the webUI
    When the user browses directly to display the details of file "lorem-big.txt" in folder "simple-folder"
    And the user adds a tag "lorem" to the file using the webUI
    Then file "simple-folder/lorem.txt" should have the following tags for user "Alice"
      | lorem | normal |
    And file "simple-folder/lorem-big.txt" should have the following tags for user "Alice"
      | lorem | normal |

  @issue-5017
  Scenario: Remove a tag that already exists for a file in a folder
    Given user "Alice" has created folder "simple-folder"
    And user "Alice" has uploaded file "lorem.txt" to "simple-folder/lorem.txt"
    And the user has browsed directly to display the details of file "lorem.txt" in folder "simple-folder"
    And the user has added a tag "lorem" to the file using the webUI
    When the user browses directly to display the details of file "lorem.txt" in folder "simple-folder"
    And the user toggles a tag "lorem" on the file using the webUI
    Then file "simple-folder/lorem.txt" should have no tags for user "Alice"

  @issue-5017
  Scenario: Create and add tag on a shared file
    Given user "Alice" has created folder "simple-folder"
    And user "Alice" has uploaded file "lorem.txt" to "lorem.txt"
    When the user renames file "lorem.txt" to "coolnewfile.txt" using the webUI
    And the user browses directly to display the details of file "coolnewfile.txt" in folder ""
    And the user adds a tag "tag1" to the file using the webUI
    And the user shares file "coolnewfile.txt" with user "Brian Murphy" using the webUI
    And the user re-logs in with username "Brian" and password "%alt2%" using the webUI
    And the user browses directly to display the details of file "coolnewfile.txt" in folder ""
    And the user adds a tag "tag2" to the file using the webUI
    Then file "coolnewfile.txt" should have the following tags for user "Alice"
      | tag1 | normal |
      | tag2 | normal |
    And file "coolnewfile.txt" should have the following tags for user "Brian"
      | tag1 | normal |
      | tag2 | normal |

  @issue-5017
  Scenario: Delete a tag in a shared file
    Given user "Alice" has created folder "simple-folder"
    And user "Alice" has uploaded file "lorem.txt" to "lorem.txt"
    When the user renames file "lorem.txt" to "coolnewfile.txt" using the webUI
    And the user browses directly to display the details of file "coolnewfile.txt" in folder ""
    And the user adds a tag "tag1" to the file using the webUI
    And the user shares file "coolnewfile.txt" with user "Brian Murphy" using the webUI
    And the user re-logs in with username "Brian" and password "%alt2%" using the webUI
    Then file "coolnewfile.txt" should have the following tags for user "Brian"
      | tag1 | normal |
    When the user browses directly to display the details of file "coolnewfile.txt" in folder ""
    And the user deletes tag with name "tag1" using the webUI
    Then tag "tag1" should not exist for user "Alice"
    And tag "tag1" should not exist for user "Brian"
