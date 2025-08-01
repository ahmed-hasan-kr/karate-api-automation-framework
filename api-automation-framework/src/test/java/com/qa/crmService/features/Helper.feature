Feature: Helper class


  @getOverlappedBooks
  Scenario: Overlapped Contract

    * def getOverlapContractId =
      """
      function(contracts) {
        for(var i = 0; i < contracts.length; i++) {
          if(contracts[i].hasOverlap == true)
          {
            return contracts[i].id;
          }
        }
      }
      """

  @getNonOverlappedContract
  Scenario: Non-Overlapped methods
    * def getNonOverlapContractId =
      """
      function(contracts) {
        for(var i = 0; i < contracts.length; i++) {
          if(contracts[i].hasOverlap == false)
          {
            return contracts[i].id;
          }
        }
      }
      """

  @dateGenerator
  Scenario: Generate Dates
    * def LocalDate = Java.type('java.time.LocalDate')
    * def result = {}
    * result.todaysDate = LocalDate.now().toString()
    * result.nextYearDate = LocalDate.now().plusYears(1).toString()
    * result.currentIsoDate = new Date().toISOString()
    * karate.set('result', result)

  @getValuesFromSource
  Scenario: Eval field

    * def extractFields =
      """
      function(source, fields, pathTemplate) {
        var result = {};
        fields.forEach(function(f) {
          var path = pathTemplate.replace('<<field>>', f);
          result[f] = karate.jsonPath(source, path);
        });
        return result;
      }
      """