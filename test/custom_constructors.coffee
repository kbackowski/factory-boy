require ('should')
Factory = require('../src/index').Factory

class Profile extends Object

Profile.buildOne = (attrs) ->
  new Profile(attrs)

Profile.createOne = (attrs, callback) ->
  callback(null, new Profile(attrs))

describe Factory, ->
  before ->
    Factory.define 'profile', class: Profile, ->
      @avatar_url = 'http://example.com/img.png'

      @initializeWith = (attributes, callback) ->
        callback(null, Profile.buildOne(attributes))

      @createWith = (attributes, callback) ->
        Profile.createOne(attributes, callback)

  describe '#createWith', ->
    it 'should pass attributes to factory', ->
      Factory.create 'profile', (err, profile) ->
        profile.should.have.property('avatar_url', 'http://example.com/img.png')
