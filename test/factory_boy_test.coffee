require ('should')
Factory = require('../src/index').Factory

Factory.define 'user', {class: Object}, ->
  @first_name = 'John'
  @last_name = 'Smith'

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
