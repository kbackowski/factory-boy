require('should')
global.Factory = require('../src/index').Factory

beforeEach ->
  Factory.reload()