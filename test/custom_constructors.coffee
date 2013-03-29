require ('should')
Factory = require('../src/index').Factory

class Profile extends Object

Profile.buildOne = (attrs) ->
  new Profile(attrs)

Profile.createOne = (attrs, callback) ->
  callback(null, new Profile(attrs))

describe Factory, ->
  before ->
    Factory.factories = {}

    Factory.define 'profile', class: Profile, ->
      @avatar_url = 'http://example.com/img.png'

      @initializeWith = (klass, attributes, callback) ->
        callback(null, klass.buildOne(attributes))

      @createWith = (klass, attributes, callback) ->
        klass.createOne(attributes, callback)

  describe '#createWith', ->
    it 'should pass attributes to factory', ->
      Factory.create 'profile', (err, profile) ->
        profile.should.have.property('avatar_url', 'http://example.com/img.png')
