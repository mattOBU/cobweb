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

Currently the application is deployed to Heroku as [stark-springs-1195](http://stark-springs-1195.herokuapp.com/)


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

Lorem ipsum dolor sit amet, consectetur adipiscing elit.
