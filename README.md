Cobweb
=========

Cobweb prototype application, implementing the wireframes provided
[here](http://prezi.com/64mbi6llbbm4/the-cobweb-tree-v2/)


Database
--------

This application uses PostgreSQL with ActiveRecord.

Development
-----------

-   Template Engine: Haml
-   Testing Framework: RSpec and Factory Girl and Cucumber
-   Front-end Framework: Twitter Bootstrap 3.0 (Sass)
-   Form Builder: SimpleForm
-   Authentication: Devise
-   Authorization: CanCan
-   Admin: None

Email
-----

The application is configured to send email using a SendGrid account.

Email delivery is disabled in development.


Deploy
------

Currently the application is deployed to Heroku as [cobweb-staging](http://cobweb-staging.herokuapp.com/)


Getting Started
---------------

* Remember to set up your .env with at least the following variables:

```
ADMIN_NAME=First User
ADMIN_EMAIL=user@example.com
ADMIN_PASSWORD=changeme
ROLES=[admin, user, VIP]
PORT=3031
```


Documentation and Support
-------------------------

This is the only documentation.

#### Issues

Lorem ipsum dolor sit amet, consectetur adipiscing elit.


Credits
-------

Lorem ipsum dolor sit amet, consectetur adipiscing elit.

License
-------

Copyright 2014 Mastodon C Ltd

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
