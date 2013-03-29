_ = require('underscore')._
require ('should')
Factory = _.clone(require('../src/index').Factory)

describe 'Factory sequences', ->
  before ->
    Factory.factories = {}

    class User extends Object
    class Admin extends Object

    Factory.define 'user', class: User, ->
      @sequence 'email', (n, callback) ->
        callback(null, "test#{n}@example.com")

    Factory.define 'admin', class: Admin, ->
      @sequence 'login', (n, callback) ->
        callback(null, "admin#{n}")

  it 'should start from 1', ->
    Factory.build 'user', (err, user) ->
      user.should.have.property('email', 'test1@example.com')

  it 'should increment by 1', ->
    Factory.build 'user', (err, user) ->
      user.should.have.property('email', 'test2@example.com')

  it 'should not conflict with other sequences', ->
    Factory.build 'admin', (err, admin) ->
      admin.should.have.property('login', 'admin1')


