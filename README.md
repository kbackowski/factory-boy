Factory Boy
===========

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

```
Factory = require('factory-boy').Factory

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

```
initializeWith: (klass, attributes, callback) ->
  callback(null, new klass(attributes))
  
createWith: (klass, attributes, callback) ->
  klass.create(attributes, callback)
```

You can overwrite this methods on global level or per each factory :

```
# overwriting globally
Factory = require('factory-boy').Factory

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

```
Factory.define 'user', class: User, ->
  @first_name = 'John'
  @salt = (callback) -> 
    time = new Date()
    callback(null, "@{first_name}#{time}")
```

Additionally lazy functions are evaluated in the defined order.

```
Factory.define 'user', class: User, ->
  @number1 = (callback) -> callback(null, 10)
  @number2 = (callback) -> callback(null, @number1 + 10)
```

## Associations

```
Factory.define 'user', class: User, ->
  @first_name = 'John'
  @association('profile')

Factory.define 'profile', class: Profile, ->
  @avatar_url = 'http://example.com/img.png'

Factory.create 'user', (err, user) ->
  console.log user.profile_id
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
