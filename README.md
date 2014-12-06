social-login-rails
==================
[![Build Status](https://travis-ci.org/igordeoliveirasa/social-login-rails.svg?branch=master)](https://travis-ci.org/igordeoliveirasa/social-login-rails)
[![Test Coverage](https://codeclimate.com/github/igordeoliveirasa/social-login-rails/badges/coverage.svg)](https://codeclimate.com/github/igordeoliveirasa/social-login-rails)
[![Code Climate](https://codeclimate.com/github/igordeoliveirasa/social-login-rails/badges/gpa.svg)](https://codeclimate.com/github/igordeoliveirasa/social-login-rails)

Configuring Environment Variables
==================

You must set some environment variables.
For development and test create a file called as .env so as to configure the environment variables.

Example:
```console
FACEBOOK_APP_ID=453476448077542
FACEBOOK_APP_SECRET=fa84f2af46d2907a47c860db6a8decc3

GOOGLE_APP_ID=355945761428-pfsttrc8bpr879fdn90rko66q5556a94.apps.googleusercontent.com
GOOGLE_APP_SECRET=1R2zrwCVKr5UXOYr1IHSIkRm

TWITTER_APP_ID=EgLF8LC1Z4wUlfICeJ1WLoUtR
TWITTER_APP_SECRET=Jtrz9hRHGSKVLBLYBLInfZSt0gDKppHQn1zok9drX8B4I3ZrU4

LINKEDIN_APP_ID=7842e3c3km4uqo
LINKEDIN_APP_SECRET=j0JQTuAZhHTg6vtk

GITHUB_APP_ID=38b27b7cc776278c49b2
GITHUB_APP_SECRET=a8fb0c1db81b9d9b87b0ba270e6ac4ef54f9756f
```
These values are just an example. You must replace the values in order to point to your real variables.
In production the environement variables won't be loaded. They must be set up on the real environment.

Running the Server
==================

Installing bundles:
```console
bundle install
```

Updating the database:
```console
rake db:migrate
```

Now, you are able to start the server:
```console
rails server
```

Access through the browser the following address: http://0.0.0.0:3000, and it's done!
