Feature: Validate Books API endpoints for search, filter, and sorting

  Background: Define URL and headers
    * configure ssl = true
    * def token = callonce read('Oauth.feature@getOAuth2Token')
    Given url 'https://api.books.com'
    And header Authorization = token.BearerToken
    And header Content-Type = 'application/json'

  @regression
  Scenario Outline: Validate search endpoint for invalid sort or filter parameters
    Given path '/v1/books/search'
    And params { filter: { genre: <genre>, author: <author> }, sort: <sortValue> }
    When method GET
    Then status <statusCode>

    * def errorCode = karate.jsonPath(response, "$.errors[0].code")
    * def errorMessage = karate.jsonPath(response, "$.errors[0].message")
    * match errorCode == "<expectedErrorCode>"
    * match errorMessage == "<expectedErrorMessage>"

    Examples:
      | genre       | author         | sortValue       | expectedErrorCode | expectedErrorMessage     | statusCode |
      | Fiction     | UnknownAuthor  | invalidSort     | E400              | Invalid Sort Parameter   | 400        |
      | NonFiction  | TestAuthor     | -               | E404              | Author Not Found         | 404        |

  @smoke @regression
  Scenario Outline: Validate sorting of books by <sortParameter>
    Given path '/v1/books'
    And params { sort: <sortParameter>, page: { size: 50, number: 1 } }
    When method GET
    Then status 200

    * def books = $.data[*].<parameterPath>
    * def sortedBooks = karate.sort(books, function(a, b) { return a.localeCompare(b) })
    * match books == sortedBooks

    Examples:
      | sortParameter   | parameterPath      |
      | title           | title             |
      | publishDate     | publishDate       |

  @smoke @regression
  Scenario Outline: Validate filtering of books by date range
    * def today = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date())
    * def oneYearAgo = karate.date(today).minusDays(365).toString('yyyy-MM-dd')

    Given path '/v1/books'
    And params { filter: { publishDate: { gte: <startDate>, lte: <endDate> } }, page: { size: 50 } }
    When method GET
    Then status 200

    * def books = $.data[*]
    * def validateDateRange = function(book) { return book.publishDate >= <startDate> && book.publishDate <= <endDate> }
    * match each books == '#? validateDateRange(_)'

    Examples:
      | startDate   | endDate    |
      | #(oneYearAgo) | #(today) |

  @regression
  Scenario Outline: Validate search endpoint with invalid filter parameters
    Given path '/v1/books/search'
    And params <queryParameters>
    When method GET
    Then status <expectedHttpCode>

    * def errorCode = karate.jsonPath(response, "$.errors[0].code")
    * match errorCode == '<expectedErrorCode>'
    * def errorMessage = karate.jsonPath(response, "$.errors[0].message")
    * match errorMessage == '<expectedErrorMessage>'

    Examples:
      | queryParameters                                      | expectedHttpCode | expectedErrorCode | expectedErrorMessage       |
      | { filter: { genre: 'InvalidGenre' } }               | 400              | E400              | Invalid Genre              |
      | { filter: { author: 'UnknownAuthor' } }             | 404              | E404              | Author Not Found           |

  @regression
  Scenario Outline: Validate books endpoint pagination parameters
    Given path '/v1/books'
    And params { page: { size: <pageSize>, number: <pageNumber> } }
    When method GET
    Then status <expectedHttpCode>

    * def pageOffset = $.meta.page.offset
    * match pageOffset == '<expectedPageOffset>'

    Examples:
      | pageSize | pageNumber | expectedHttpCode | expectedPageOffset |
      | 10       | 1          | 200              | 0                  |
      | 25       | 2          | 200              | 25                 |

  @smoke @regression
  Scenario: Validate fetching books with valid parameters
    Given path '/v1/books'
    And params { filter: { genre: 'Fiction' }, sort: 'title', page: { size: 10 } }
    When method GET
    Then status 200

    * def books = $.data[*]
    * match books.length == 10
    * assert books.every(book => book.genre == 'Fiction')

  @regression
  Scenario Outline: Validate fetching books with invalid parameters
    Given path '/v1/books'
    And params <queryParameters>
    When method GET
    Then status <expectedHttpCode>

    * def errorCode = karate.jsonPath(response, "$.errors[0].code")
    * match errorCode == '<expectedErrorCode>'
    * def errorMessage = karate.jsonPath(response, "$.errors[0].message")
    * match errorMessage == '<expectedErrorMessage>'

    Examples:
      | queryParameters                                      | expectedHttpCode | expectedErrorCode | expectedErrorMessage       |
      | { filter: { genre: 'InvalidGenre' } }               | 400              | E400              | Invalid Genre              |
      | { filter: { publishDate: { gte: '2023-13-01' } } }  | 400              | E400              | Invalid Date Format        |

  @smoke @regression
  Scenario: Validate fetching books with multiple filters
    Given path '/v1/books/search'
    And params { filter: { genre: 'Fiction', author: 'John Doe' }, sort: 'title', page: { size: 10 } }
    When method GET
    Then status 200

    * def books = $.data[*]
    * assert books.every(book => book.genre == 'Fiction' && book.author == 'John Doe')

  @regression
  Scenario Outline: Validate fetching books with invalid sort parameters
    Given path '/v1/books'
    And params { sort: <sortParameter>, page: { size: 10 } }
    When method GET
    Then status <expectedHttpCode>

    * def errorCode = karate.jsonPath(response, "$.errors[0].code")
    * match errorCode == '<expectedErrorCode>'
    * def errorMessage = karate.jsonPath(response, "$.errors[0].message")
    * match errorMessage == '<expectedErrorMessage>'

    Examples:
      | sortParameter | expectedHttpCode | expectedErrorCode | expectedErrorMessage    |
      | invalidSort   | 400              | E400              | Invalid Sort Parameter  |