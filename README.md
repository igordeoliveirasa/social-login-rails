[![Build Status](https://travis-ci.org/igordeoliveirasa/social-login-rails.svg?branch=master)](https://travis-ci.org/igordeoliveirasa/social-login-rails)
[![Coverage Status](https://coveralls.io/repos/igordeoliveirasa/social-login-rails/badge.png)](https://coveralls.io/r/igordeoliveirasa/social-login-rails)

social-login-rails
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
