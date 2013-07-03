Factory Boy
===========

[![Build Status](https://travis-ci.org/kbackowski/factory-boy.png?branch=master)](https://travis-ci.org/kbackowski/factory-boy)
[![Coverage Status](https://coveralls.io/repos/kbackowski/factory-boy/badge.png?branch=master)](https://coveralls.io/r/kbackowski/factory-boy?branch=master)
[![NPM version](https://badge.fury.io/js/factory-boy.png)](http://badge.fury.io/js/factory-boy)

Factory Boy is an library for Node.js which provides factories for objects creation.
It's highly inspired by the fabulous [factory\_girl](http://github.com/thoughtbot/factory_girl) library for Ruby on Rails.

It comes with support for :

* associations
* lazy attributes
* defining factory initialization and creation methods

## Installation

```
npm install factory-boy
```

## Defining factories

``` coffeescript
Factory = require('factory-boy')

Factory.define 'user', class: User, ->
  @first_name = 'John'
  @last_name = 'Smith'
  @pin = (callback) -> callback(null, Math.floor(Math.random()*10000))

Factory.build 'user', (err, user) ->
  console.log user

Factory.create 'user', (err, user) ->
  console.log user
```

## Custom intialization and creation methods

Factory Boy use initializeWith and createWith methods for building and creating factory objects :

``` coffeescript
initializeWith: (klass, attributes, callback) ->
  callback(null, new klass(attributes))

createWith: (klass, attributes, callback) ->
  klass.create(attributes, callback)
```

You can overwrite this methods on global level or per each factory :

``` coffeescript
# overwriting globally
Factory = require('factory-boy')

Factory.initializeWith = (klass, attributes, callback) ->
  callback(null, new klass.build(attributes))

Factory.createWith = (klass, attributes, callback) ->
  new klass.build(attributes).create(callback)

# overwriting per factory
Factory.define 'user', class: User, ->
  @initializeWith = (klass, attributes, callback) ->
    callback(null, klass.build(attributes))

  @createWith = (klass, attributes, callback) ->
    new klass.build(attributes).create(callback)
```

## Lazy attributes

Attributes defined by functions are evaluated upon object intialization/creation.
Lazy functions context are set to factory instance so it's possible to use already defined attributes.

``` coffeescript
Factory.define 'user', class: User, ->
  @first_name = 'John'
  @salt = (callback) ->
    time = new Date()
    callback(null, "#{first_name}#{time}")
```

Additionally lazy functions are evaluated in the defined order.

``` coffeescript
Factory.define 'user', class: User, ->
  @number1 = (callback) -> callback(null, 10)
  @number2 = (callback) -> callback(null, @number1 + 10)
```

## Sequences

Sequences can be used for creating record with unique attributes i.e. emails. They are creating lazy attribute for given field with iterator passed as first argument.

``` coffeescript
Factory.define 'user', class: User, ->
  @sequence 'email', (n, callback) ->
    callback(null, "test#{n}example.com")
```

First variable in callback will be increment for each records, starting from value 1. Therefore creating user factories will return records with unique emails.

## Associations

``` coffeescript
Factory.define 'user', class: User, ->
  @first_name = 'John'
  @association('profile')

Factory.define 'profile', class: Profile, ->
  @avatar_url = 'http://example.com/img.png'

Factory.create 'user', (err, user) ->
  console.log user.profile_id
```

When using associations you can pass field name as first parameter.

``` coffeescript
Factory.define 'user', class: User, ->
  @first_name = 'John'
  @association('user_profile_id', 'profile')

```

Also you can set values to associated factory.

``` coffeescript
Factory.define 'user', class: User, ->
  @first_name = 'John'
  @association('profile', avatar_url: 'http://example.com/img2.png')
```

By default Factory Boy will use id field from associated factory. This can be changed by passing factory options.

``` coffeescript
Factory.define 'user', class: User, ->
  @first_name = 'John'
  @association('profile', factory: {field: 'external_id'})
```

## Contributing

1. Fork it
2. Install dependencies

```
npm install
```

3. Make your changes on branch and make sure all tests pass

```
npm test
```

4. Submit your pull request !
