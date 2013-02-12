require ('should')
Factory = require('../src/index').Factory

class User extends Object

User.create = (attrs = {}, callback) ->
  callback(null, attrs)

Factory.define 'user', class: User, ->
  @first_name = 'John'
  @last_name = 'Smith'
  @random_number = -> Math.floor(Math.random()*10000) + 30000

  @traits 'admin', ->
    # ...

  @before 'save', ->
    # ...


describe Factory, ->
  describe '#build', ->
    it 'should use default values for attributes', ->
      user = Factory.build('user')
      user.should.have.property('first_name', 'John')
      user.should.have.property('last_name', 'Smith')

    it 'should overwrite default values for attributes with provided ones', ->
      user = Factory.build('user', last_name: 'Brown')
      user.should.have.property('last_name', 'Brown')

    it 'should not affect other factories', ->
      Factory.build('user', last_name: 'Brown').should.have.property('last_name', 'Brown')
      Factory.build('user', last_name: 'Williams').should.have.property('last_name', 'Williams')

    it 'should handle lazy attributes', ->
      user = Factory.build('user')
      user.should.have.property('random_number')
      user.random_number.should.be.a('number')

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

    it 'should handle lazy attributes', (done) ->
      Factory.create 'user', (err, user) ->
        user.should.have.property('random_number')
        user.random_number.should.be.a('number')
        done()