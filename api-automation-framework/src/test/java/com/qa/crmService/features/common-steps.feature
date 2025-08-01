@ignore
Feature: Common reusable steps

  Background:
    * url baseUrl
    * configure headers = headers

  Scenario: Validate response status and time
    * assert responseStatus == expectedStatus
    * assert responseTime < timeout

  Scenario: Validate JSON schema
    * def schema = read('classpath:schemas/' + schemaFile)
    * match response == schema

  Scenario: Generate random data
    * def randomEmail = 'test' + java.lang.System.currentTimeMillis() + '@example.com'
    * def randomName = 'User' + java.lang.System.currentTimeMillis()
    * def randomId = Math.floor(Math.random() * 1000)