Feature: Users API CRUD Operations

  Background:
    * url baseUrl
    * configure headers = headers
    * def testData = Java.type('com.automation.utils.TestDataGenerator')

  Scenario: Get all users
    Given path '/users'
    When method GET
    Then status 200
    And assert response.length == 10
    And match each response[*] contains { id: '#number', name: '#string', email: '#string' }

  Scenario: Get user by ID
    Given path '/users/1'
    When method GET
    Then status 200
    And match response contains { id: 1, name: '#string', email: '#string' }
    And match response.address contains { city: '#string', zipcode: '#string' }

  Scenario: Get non-existent user
    Given path '/users/999'
    When method GET
    Then status 404

  Scenario: Create new user
    * def userData = testData.generateUserData()
    Given path '/users'
    And request userData
    When method POST
    Then status 201
    And match response contains { id: '#number' }
    And match response.name == userData.name
    And match response.email == userData.email

  Scenario: Update user
    * def userId = 1
    * def updateData =
      """
      {
    "id": #(userId),
    "name": "Updated User Name",
    "username": "updateduser",
    "email": "updated@example.com"
    }
    """
    Given path '/users/' + userId
    And request updateData
    When method PUT
    Then status 200
    And match response.name == "Updated User Name"
    And match response.email == "updated@example.com"

  Scenario: Partial update user
    * def userId = 1
    * def patchData = { "name": "Partially Updated Name" }
    Given path '/users/' + userId
    And request patchData
    When method PATCH
    Then status 200
    And match response.name == "Partially Updated Name"

  Scenario: Delete user
    * def userId = 1
    Given path '/users/' + userId
    When method DELETE
    Then status 200