require('should')
Factory = require('../src/index').Factory

class User extends Object
class Profile extends Object

User.create = (attrs = {}, callback) ->
  callback(null, new User(attrs))

Profile.buildOne = (attrs) ->
  new Profile(attrs)

Profile.createOne = (attrs, callback) ->
  callback(null, new Profile(attrs))

describe Factory, ->
  beforeEach ->
    Factory.factories = {}

    Factory.define 'user', class: User, ->
      @first_name = 'John'
      @last_name = 'Smith'
      @lazy_number1 = (callback) -> callback(null, 10)
      @lazy_number2 = (callback) -> callback(null, 15)
      @lazy_number3 = (callback) ->
        callback(null, @lazy_number1 + @lazy_number2)

      @traits 'admin', ->
        # ...

      @before 'save', ->
        # ...

    Factory.define 'profile', class: Profile, ->
      @avatar_url = 'http://example.com/img.png'

      @initializeWith = (klass, attributes, callback) ->
        callback(null, klass.buildOne(attributes))

      @createWith = (klass, attributes, callback) ->
        klass.createOne(attributes, callback)

  describe '#define', ->
    it 'should throw when factory is alredy defined', ->
      (-> Factory.define 'user').should.throw('Factory already defined: user')

  describe '#build', ->
    it 'should use default values for attributes', ->
      Factory.build 'user', (err, user) ->
        user.should.have.property('first_name', 'John')
        user.should.have.property('last_name', 'Smith')

    it 'should overwrite default values for attributes with provided ones', ->
      Factory.build 'user', last_name: 'Brown', (err, user) ->
        user.should.have.property('last_name', 'Brown')

    it 'should not affect other factories', ->
      Factory.build 'user', last_name: 'Brown', (err, user) ->
        user.should.have.property('last_name', 'Brown')
        Factory.build 'user', last_name: 'Williams', (err, user) ->
          user.should.have.property('last_name', 'Williams')

    it 'should handle lazy attribute', ->
      Factory.build 'user', (err, user) ->
        user.should.have.property('lazy_number1', 10)

    it 'should handle multiple lazy attributes', ->
      Factory.build 'user', (err, user) ->
        user.should.have.property('lazy_number1', 10)
        user.should.have.property('lazy_number2', 15)

    it 'should handle lazy attribute that depends on other lazy attribute', ->
      Factory.build 'user', (err, user) ->
        user.should.have.property('lazy_number3', 25)

    it 'should allow for overwriting default initialization method', ->
      Factory.build 'profile', (err, profile) ->
        profile.should.have.property('avatar_url', 'http://example.com/img.png')

    it 'should throw when factory is not defined', ->
      (-> Factory.build 'test').should.throw('Factory not defined: test')

  describe '#create', ->
    it 'should use default values for attributes', (done) ->
      Factory.create 'user', (err, user) ->
        user.should.have.property('first_name', 'John')
        user.should.have.property('last_name', 'Smith')
        done()

    it 'should overwrite default values for attributes with provided ones', (done) ->
      Factory.create 'user', last_name: 'Brown', (err, user) ->
        user.should.have.property('last_name', 'Brown')
        done()

    it 'should not affect other factories', (done) ->
      Factory.create 'user', last_name: 'Brown', (err, user) ->
        user.should.have.property('last_name', 'Brown')
        Factory.create 'user', last_name: 'Williams', (err, user) ->
          user.should.have.property('last_name', 'Williams')
          done()

    it 'should handle lazy attribute', (done) ->
      Factory.create 'user', (err, user) ->
        user.should.have.property('lazy_number1', 10)
        done()

    it 'should handle multiple lazy attributes', (done) ->
      Factory.create 'user', (err, user) ->
        user.should.have.property('lazy_number1', 10)
        user.should.have.property('lazy_number2', 15)
        done()

    it 'should handle lazy attribute that depends on other lazy attribute', (done) ->
      Factory.create 'user', (err, user) ->
        user.should.have.property('lazy_number3', 25)
        done()

    it 'should allow for overwriting default create method', ->
      Factory.create 'profile', (err, profile) ->
        profile.should.have.property('avatar_url', 'http://example.com/img.png')

    it 'should throw when factory is not defined', ->
      (-> Factory.create 'test').should.throw('Factory not defined: test')