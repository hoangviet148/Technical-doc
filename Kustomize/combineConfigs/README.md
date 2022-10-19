## combining config data from devops and developers

Scenario: you have a Java-based server storefront in production that various internal development teams (signups, checkout, search, etc.) contribute to.

The server runs in different environments: development, testing, staging and production, accepting configuration parameters from java property files.

Using one big properties file for each environment is difficult to manage. The files change frequently, and have to be changed by devops exclusively because

1. the files must at least partially agree on certain values that devops cares about and that developers ignore and
2. because the production properties contain sensitive data like production database credentials.