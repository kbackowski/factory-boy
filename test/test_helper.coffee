require('should')
global.Factory = require('../src/index')

beforeEach ->
  Factory.reload()