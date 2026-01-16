# User Management Feature Example

Feature: User Management
    As a system administrator
    I want to manage user accounts
    So that I can control access to the system

    Background:
        Given the system is running
        And the database is initialized
        And I am authenticated as admin

    Scenario: Create a new user successfully
        Given no user exists with email "newuser@example.com"
        When I create a user with the following details:
            | Field     | Value                |
            | Email     | newuser@example.com  |
            | Name      | New User             |
            | Password  | SecurePass123!       |
            | Role      | User                 |
        Then the user creation should succeed
        And the user should be stored in the database
        And a welcome email should be sent to "newuser@example.com"
        And the password should be hashed

    Scenario: Cannot create user with existing email
        Given a user exists with email "existing@example.com"
        When I create a user with email "existing@example.com"
        Then the user creation should fail
        And I should see error "User with this email already exists"

    Scenario Outline: Validate user input
        When I create a user with <field> as "<value>"
        Then the validation should <result>
        And I should see error message "<error>"

        Examples:
            | field    | value            | result  | error                          |
            | email    |                  | fail    | Email is required              |
            | email    | invalid          | fail    | Invalid email format           |
            | password | short            | fail    | Password must be at least 8    |
            | password | nouppercaseX1!   | fail    | Password must contain uppercase|
            | name     |                  | fail    | Name is required               |

    Scenario: Update user details
        Given a user exists with id "user-123"
        When I update user "user-123" with:
            | Field | Value           |
            | Name  | Updated Name    |
            | Role  | Administrator   |
        Then the update should succeed
        And the user details should be updated in the database

    Scenario: Delete a user
        Given a user exists with id "user-456"
        When I delete user "user-456"
        Then the deletion should succeed
        And the user should be removed from the database

    Scenario: Search users by criteria
        Given the following users exist:
            | Email              | Name      | Role  |
            | john@example.com   | John Doe  | User  |
            | jane@example.com   | Jane Doe  | Admin |
            | bob@example.com    | Bob Smith | User  |
        When I search for users with:
            | Field | Value |
            | Role  | User  |
        Then I should see 2 users
        And the results should contain "john@example.com"
        And the results should contain "bob@example.com"
