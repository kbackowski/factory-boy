require('./test_helper')

class User extends Object
  @create: (attrs = {}, callback) ->
    callback(null, new User(attrs))

class Profile extends Object
  @create: (attrs = {}, callback) ->
    callback(null, new Profile(attrs))

describe "Factory#association", ->
  beforeEach ->
    Factory.define 'admin', class: User, ->
      @id = 1

    Factory.define 'user', class: User, ->
      @id = 2

    Factory.define 'profile', class: Profile, ->
      @id = 3

      @association 'user', first_name: 'Kamil'

    Factory.define 'adminProfile', class: Profile, ->
      @association 'user', factory: {name: 'admin'}

  it 'should create association when building factory', ->
    Factory.build 'profile', (err, profile) ->
      profile.should.have.property('user_id', 2)

  it 'should create association from given factory name', ->
    Factory.build 'adminProfile', (err, adminProfile) ->
      adminProfile.should.have.property('user_id', 1)

  it 'should create association when creating factory', ->
    Factory.create 'profile', (err, profile) ->
      profile.should.have.property('user_id', 2)