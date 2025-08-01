Feature: Comments API Operations

  Background:
    * url baseUrl
    * configure headers = headers

  Scenario: Get all comments
    Given path '/comments'
    When method GET
    Then status 200
    And assert response.length == 500
    And match each response[*] contains { id: '#number', name: '#string', email: '#string', body: '#string', postId: '#number' }

  Scenario: Get comments by post ID
    * def postId = 1
    Given path '/posts/' + postId + '/comments'
    When method GET
    Then status 200
    And match each response[*].postId == postId
    And match each response[*] contains { id: '#number', name: '#string', email: '#string' }

  Scenario: Get comments using query parameter
    * def postId = 1
    Given path '/comments'
    And param postId = postId
    When method GET
    Then status 200
    And match each response[*].postId == postId

  Scenario: Validate comment email format
    Given path '/comments/1'
    When method GET
    Then status 200
    And match response.email == '#regex .+@.+\\..+'