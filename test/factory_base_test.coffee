require('./test_helper')

FactoryBase = require('../src/factory_base')

class User extends Object

describe 'FactoryBase', ->
  describe '#attributes', ->
    it 'should return only factory defined attributes', ->
      factory = new FactoryBase class: User, ->
        @name = 'john'
        @email = 'john@example.com'
        @sequence 'login', (n, callback) -> callback(null, "admin#{n}")
        @association 'profile'

        @initializeWith = (klass, attributes, callback) ->
          callback(null, new klass(attributes))

        @createWith = (klass, attributes, callback) ->
          klass.create(attributes, callback)

      factory.attributes().should.eql(name: 'john', email: 'john@example.com')
