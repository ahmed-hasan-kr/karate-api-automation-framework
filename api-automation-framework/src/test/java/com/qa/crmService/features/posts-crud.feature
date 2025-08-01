Feature: Posts API CRUD Operations

  Background:
    * url baseUrl
    * configure headers = headers
    * def testData = Java.type('com.automation.utils.TestDataGenerator')

  Scenario: Get all posts
    Given path '/posts'
    When method GET
    Then status 200
    And assert response.length == 100
    And match each response[*] contains { id: '#number', title: '#string', body: '#string', userId: '#number' }

  Scenario: Get posts by user ID
    * def userId = 1
    Given path '/posts'
    And param userId = userId
    When method GET
    Then status 200
    And match each response[*].userId == userId

  Scenario: Get post by ID
    Given path '/posts/1'
    When method GET
    Then status 200
    And match response contains { id: 1, title: '#string', body: '#string', userId: '#number' }

  Scenario: Create new post
    * def postData = testData.generatePostData()
    Given path '/posts'
    And request postData
    When method POST
    Then status 201
    And match response contains { id: '#number' }
    And match response.title == postData.title
    And match response.body == postData.body
    And match response.userId == postData.userId

  Scenario: Update post
    * def postId = 1
    * def updateData =
      """
      {
    "id": #(postId),
    "title": "Updated Post Title",
    "body": "Updated post body content",
    "userId": 1
    }
    """
    Given path '/posts/' + postId
    And request updateData
    When method PUT
    Then status 200
    And match response.title == "Updated Post Title"
    And match response.body == "Updated post body content"

  Scenario: Delete post
    * def postId = 1
    Given path '/posts/' + postId
    When method DELETE
    Then status 200

  Scenario Outline: Get posts with different IDs
    Given path '/posts/<postId>'
    When method GET
    Then status 200
    And match response.id == <postId>

    Examples:
      | postId |
      | 1      |
      | 2      |
      | 3      |