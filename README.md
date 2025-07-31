# karate-api-automation-framework
# Run with environment in IDE
## In Run/Debug Configurations or Edit Configuration --> VM Options :
add your respective environment
```java
 -Dkarate.env=dev
```

```java
 -Dkarate.env=test
```

Or in Maven from the command line:

```
mvn test -DargLine="-Dkarate.env=test"
```
