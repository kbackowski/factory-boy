require('./test_helper')

class User extends Object
  @create: (attrs = {}, callback) ->
    callback(null, new User(attrs))

class Profile extends Object
  @create: (attrs = {}, callback) ->
    callback(null, new Profile(attrs))

class Facebook extends Object
  @create: (attrs = {}, callback) ->
    callback(null, new Profile(attrs))

describe "Factory#association", ->
  beforeEach ->
    Factory.define 'admin', class: User, ->
      @id = 1

    Factory.define 'user', class: User, ->
      @id = 2
      @association 'external_facebook_id', 'facebook', factory: {field: 'uuid'}

    Factory.define 'profile', class: Profile, ->
      @id = 3
      @association 'user', first_name: 'Kamil'

    Factory.define 'facebook', class: Facebook, ->
      @uuid = 10000001

    Factory.define 'adminProfile', class: Profile, ->
      @association 'user', factory: {name: 'admin'}

  it 'should create association when building factory', ->
    Factory.build 'profile', (err, profile) ->
      profile.should.have.property('user_id', 2)

  it 'should create association from given factory name', ->
    Factory.build 'adminProfile', (err, adminProfile) ->
      adminProfile.should.have.property('user_id', 1)

  it 'should assign association to given field', ->
    Factory.build 'user', (err, user) ->
      user.should.have.property('external_facebook_id', 10000001)

  it 'should create association when creating factory', ->
    Factory.create 'profile', (err, profile) ->
      profile.should.have.property('user_id', 2)