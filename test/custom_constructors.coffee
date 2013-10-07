require('./test_helper')
sinon = require('sinon')

class Profile extends Object

Profile.buildOne = (attrs) ->
  new Profile(attrs)

Profile.createOne = (attrs, callback) ->
  callback(null, new Profile(attrs))

describe 'Factory', ->
  beforeEach ->
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

    it 'should get only factory defined attributes', (done) ->
      mock = sinon.mock(Factory._fetchFactory('profile'))
      mock.expects('createWith').withArgs(Profile, avatar_url: 'http://example.com/img.png').once().callsArgWith(2, null)

      Factory.create 'profile', ->
        mock.verify().should.be.true
        done()

  describe '#initializeWith', ->
    it 'should pass attributes to factory', ->
      Factory.build 'profile', (err, profile) ->
        profile.should.have.property('avatar_url', 'http://example.com/img.png')

    it 'should get only factory defined attributes', (done) ->
      mock = sinon.mock(Factory._fetchFactory('profile'))
      mock.expects('initializeWith').withArgs(Profile, avatar_url: 'http://example.com/img.png').once().callsArgWith(2, null)

      Factory.build 'profile', ->
        mock.verify().should.be.true
        done()