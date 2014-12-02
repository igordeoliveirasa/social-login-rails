[![Build Status](https://travis-ci.org/igordeoliveirasa/social-login-rails-facebook.svg?branch=master)](https://travis-ci.org/igordeoliveirasa/social-login-rails-facebook)
[![Coverage Status](https://coveralls.io/repos/igordeoliveirasa/social-login-rails-facebook/badge.png)](https://coveralls.io/r/igordeoliveirasa/social-login-rails-facebook)

social-login-rails-facebook
==================


Running the Server
==================

Installing bundles:
```console
bundle install
```

Configuring the devise:
```console
rails generate devise:install
```

When you are done, you are ready to add Devise to any of your models using the generator:
```console
rails generate devise User
```

Now, you are able to start the server:
```console
rails server
```

Access through the browser the following address: http://0.0.0.0:3000, and it's done!
