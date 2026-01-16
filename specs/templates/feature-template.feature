# Feature Template per Reqnroll/Gherkin

Feature: <Feature Name>
    As a <role>
    I want <feature>
    So that <benefit>

    Background:
        Given <precondition>
        And <another precondition>

    Scenario: <Scenario Name>
        Given <initial context>
        When <action>
        Then <expected outcome>
        And <another expected outcome>

    Scenario Outline: <Scenario Name with Examples>
        Given <initial context>
        When I <action> with "<parameter1>" and "<parameter2>"
        Then <expected outcome> should be "<result>"

        Examples:
            | parameter1 | parameter2 | result   |
            | value1     | value2     | result1  |
            | value3     | value4     | result2  |

    # Esempi di Step Patterns comuni

    # Given Steps (Precondizioni)
    # Given the system is running
    # Given a user exists with email "<email>"
    # Given the following products exist:
    #     | Id | Name | Price |
    #     | 1  | Item | 10.00 |
    # Given I am authenticated as "<email>"
    # Given the database is clean

    # When Steps (Azioni)
    # When I create a new <resource>
    # When I update <resource> with id "<id>"
    # When I delete <resource> with id "<id>"
    # When I search for <resource> with criteria:
    #     | Field | Value |
    #     | Name  | Test  |
    # When I <action> with the following details:
    #     | Field | Value |

    # Then Steps (Verifiche)
    # Then the <action> should succeed
    # Then the <action> should fail
    # Then I should see error "<error message>"
    # Then the response should contain:
    #     | Field | Value |
    # Then the <resource> should be <state>
    # Then I should receive <expected result>
