Factory Boy
===========

Factory Boy is an library for Node.js which provides factories for objects creation. 
It's highly inspired by the fabulous [factory\_girl](http://github.com/thoughtbot/factory_girl) library for Ruby on Rails.

It comes with support for :

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
