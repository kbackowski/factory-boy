utils = require('./utils')

class FactoryBase
  constructor: (@options = {}, callback) ->
    callback.call(@)
    @

  association: (field, name, options) ->
    options ||= {}

    if name == undefined
      name = field
      field = "#{(utils.toUnderscore(name))}_id"
    if typeof name == "object"
      options = name
      name = field
      field = "#{(utils.toUnderscore(name))}_id"

    factoryOptions = options.factory || {}
    factoryName = factoryOptions.name || name
    factoryField = factoryOptions.field || "id"

    @[field] = (callback) ->
      Factory.create factoryName, options, (err, object) ->
        callback(err, object[factoryField])

  sequence: (field, sequenceCallback) ->
    n = 1
    @[field] = (callback) ->
      sequenceCallback(n++, callback)

  attributes: ->
    result = {}
    for prop in Object.keys(@)
      result[prop] = @[prop] if typeof @[prop] != 'function' && prop != 'options'
    result

  lazyProperties: ->
    result = {}
    for prop in Object.keys(@)
      result[prop] = @[prop] if typeof @[prop] == 'function' && prop not in ['createWith', 'initializeWith']
    result

module.exports = FactoryBase