require ('should')
Factory = require('../src/index').Factory

class User extends Object
  @create: (attrs = {}, callback) ->
    callback(null, new User(attrs))

class Profile extends Object
  @create: (attrs = {}, callback) ->
    callback(null, new Profile(attrs))

describe "Factory#association", ->
  before ->
    Factory.define 'user', class: User, ->
      @id = 1

    Factory.define 'profile', class: Profile, ->
      @id = 2

      @association('user')

  it 'should create association when building factory', ->
    Factory.build 'profile', (err, profile) ->
      profile.should.have.property('user_id', 1)

  it 'should create association when creating factory', ->
    Factory.create 'profile', (err, profile) ->
      profile.should.have.property('user_id', 1)