function fn() {
    let env = karate.env; // get java system property 'karate.env'
    karate.log('karate.env system property was:', env);

    if (!env) {
        env = 'test'; // default environment
    }

    let config = {
        env: env,
        baseUrl: 'https://jsonplaceholder.typicode.com',
        timeout: 30000,
        retry: 2
    };

    // Environment specific configurations
    if (env == 'test') {
        config.baseUrl = 'https://jsonplaceholder.typicode.com';
        config.dbName = karate.properties['fed.testDBName'];
    } else if (env == 'staging') {
        config.baseUrl = 'https://staging-api.example.com';
    } else if (env == 'prod') {
        config.baseUrl = 'https://api.example.com';
    }

    // Common headers
    config.headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
    };

    // Since fetching Oauth token is involved the timeout is a little high
    karate.configure('connectTimeout', 30000);
    karate.configure('readTimeout', 30000);

    return config;
}