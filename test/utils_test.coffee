require('./test_helper')

Utils = require('../src/utils')

describe 'Utils', ->
  describe '.capitalize', ->
    it 'should capitalize string', ->
      Utils.capitalize('test').should.eql('Test')
