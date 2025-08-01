Feature: Use OAuth to generate bearer token based on client id and client credentials

  Background:
    * def tokenUrl = "https://token.com"
    * def username = karate.properties['username']
    * def password = karate.properties['pass']
    * def tokenUrl = "https://abc/token?grant_type=password&username="+ username + "&password=" + password

  @getOAuth2Token
  Scenario: Get OAuth2 Bearer Token DSL
    * configure ssl = true
    * def basicAuthToken = 'Basic ' + encodedLoginText
    * def params =
      """
      {
        'scope': 'test'
      }
      """
    Given url tokenUrl
    And def requestHeaders = { Authorization: '#(basicAuthToken)', Content-Type: 'application/x-www-form-urlencoded', Content-Length: '0'}
    Then headers requestHeaders
    And params params
    When method post
    Then status 200
    #    * print response.access_token
    * def BearerToken = 'Bearer ' + response.access_token

  @getToken
  Scenario: Get Token Bearer Token DSL
    * configure ssl = true
    * def basicAuthToken = 'Basic ' + encodedLoginText
    Given url tokenUrl
    And def requestHeaders = { Authorization: '#(basicAuthToken)', Content-Type: 'application/x-www-form-urlencoded'}
    Then headers requestHeaders
    When method post
    Then status 200
    * def bearerToken = 'Bearer ' + response.access_token

  @getOAuth2Token
  Scenario: Get OAuth2 Bearer Token DSL
    * configure ssl = true
    * def basicAuthToken = 'Basic ' + encodedLoginText
    * def params =
      """
      {
        'scope': 'read'
      }
      """
    Given url tokenUrl
    And def requestHeaders = { Authorization: '#(basicAuthToken)', Content-Type: 'application/x-www-form-urlencoded', Content-Length: '0'}
    Then headers requestHeaders
    And params params
    When method post
    Then status 200
    * def PromoBearerToken = 'Bearer ' + response.access_token