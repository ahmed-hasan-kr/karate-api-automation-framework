Feature: Validate OpenWeatherMap API endpoints for weather data

  Background: Define URL and API Key
    * configure ssl = true
    * def apiKey = 'your_openweathermap_api_key'  # Replace with your actual API key
    Given url 'https://api.openweathermap.org/data/2.5'

  @smoke @regression
  Scenario: Validate current weather data for a valid city
    Given path 'weather'
    And params { q: 'London', appid: apiKey }
    When method GET
    Then status 200

    * def cityName = $.name
    * def countryCode = $.sys.country
    * karate.log('City:', cityName, 'Country:', countryCode)
    * match cityName == 'London'
    * match countryCode == 'GB'

  @regression
  Scenario Outline: Validate current weather data for invalid city
    Given path 'weather'
    And params { q: <cityName>, appid: apiKey }
    When method GET
    Then status <statusCode>

    * def errorCode = $.cod
    * def errorMessage = $.message
    * match errorCode == <expectedErrorCode>
    * match errorMessage == <expectedErrorMessage>

    Examples:
      | cityName     | statusCode | expectedErrorCode | expectedErrorMessage      |
      | InvalidCity  | 404        | 404               | city not found            |
      |              | 400        | 400               | Nothing to geocode        |

  @smoke @regression
  Scenario: Validate 5-day weather forecast for a valid city
    Given path 'forecast'
    And params { q: 'New York', appid: apiKey }
    When method GET
    Then status 200

    * def cityName = $.city.name
    * def countryCode = $.city.country
    * def forecastList = $.list
    * karate.log('City:', cityName, 'Country:', countryCode, 'Forecast Count:', forecastList.length)
    * match cityName == 'New York'
    * match countryCode == 'US'
    * assert forecastList.length > 0

  @regression
  Scenario Outline: Validate weather data for coordinates
    Given path 'weather'
    And params { lat: <latitude>, lon: <longitude>, appid: apiKey }
    When method GET
    Then status 200

    * def cityName = $.name
    * def countryCode = $.sys.country
    * karate.log('City:', cityName, 'Country:', countryCode)
    * match cityName == <expectedCity>
    * match countryCode == <expectedCountry>

    Examples:
      | latitude  | longitude  | expectedCity | expectedCountry |
      | 51.5074   | -0.1278    | London       | GB              |
      | 40.7128   | -74.0060   | New York     | US              |

  @regression
  Scenario Outline: Validate weather data with invalid coordinates
    Given path 'weather'
    And params { lat: <latitude>, lon: <longitude>, appid: apiKey }
    When method GET
    Then status <statusCode>

    * def errorCode = $.cod
    * def errorMessage = $.message
    * match errorCode == <expectedErrorCode>
    * match errorMessage == <expectedErrorMessage>

    Examples:
      | latitude | longitude | statusCode | expectedErrorCode | expectedErrorMessage   |
      | 999      | 999       | 400        | 400               | wrong latitude         |
      | abc      | xyz       | 400        | 400               | wrong latitude         |

  @smoke @regression
  Scenario: Validate weather data for a city with units parameter
    Given path 'weather'
    And params { q: 'Tokyo', units: 'metric', appid: apiKey }
    When method GET
    Then status 200

    * def cityName = $.name
    * def temperature = $.main.temp
    * karate.log('City:', cityName, 'Temperature (Celsius):', temperature)
    * match cityName == 'Tokyo'
    * assert temperature != null

  @regression
  Scenario Outline: Validate weather data for multiple cities using city IDs
    Given path 'group'
    And params { id: <cityIds>, appid: apiKey }
    When method GET
    Then status 200

    * def cities = $.list[*].name
    * def countryCodes = $.list[*].sys.country
    * karate.log('Cities:', cities, 'Countries:', countryCodes)
    * match cities contains <expectedCity>
    * match countryCodes contains <expectedCountry>

    Examples:
      | cityIds          | expectedCity | expectedCountry |
      | 2643743,5128581  | London       | GB              |
      | 1850147,5128581  | Tokyo        | JP              |

  @smoke @regression
  Scenario: Validate weather data with optional parameters (e.g., language)
    Given path 'weather'
    And params { q: 'Paris', lang: 'fr', appid: apiKey }
    When method GET
    Then status 200

    * def cityName = $.name
    * def weatherDescription = $.weather[0].description
    * karate.log('City:', cityName, 'Weather Description (French):', weatherDescription)
    * match cityName == 'Paris'
    * assert weatherDescription != null

  @regression
  Scenario Outline: Validate weather data for invalid API key
    Given path 'weather'
    And params { q: 'Berlin', appid: <invalidApiKey> }
    When method GET
    Then status <statusCode>

    * def errorCode = $.cod
    * def errorMessage = $.message
    * match errorCode == <expectedErrorCode>
    * match errorMessage == <expectedErrorMessage>

    Examples:
      | invalidApiKey       | statusCode | expectedErrorCode | expectedErrorMessage          |
      | invalid_key         | 401        | 401               | Invalid API key. Please see   |
      |                    | 401        | 401               | Invalid API key. Please see   |