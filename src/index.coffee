utils = require('./utils')

reservedProperties = ['options', 'class', 'createWith', 'initializeWith']

class BaseFactory
  constructor: (@options = {}, callback) ->
    @class = @options['class']
    callback.call(@)
    @

  association: (name, options = {}) ->
    @["#{name}_id"] = (callback) ->
      Factory.create name, (err, object) ->
        callback(err, object.id)

  traits: ->

  before: ->

  after: ->

  initializeWith: (attributes, callback) ->
    callback(null, new @class(attributes))

  createWith: (attributes, callback) ->
    @class.create(attributes, callback)

Factory =
  factories: {}

  define: (name, options, callback) ->
    @factories[name] = new BaseFactory(options, callback)

  build: (name, attrs = {}, callback) ->
    if typeof attrs == 'function'
      callback = attrs

    factory = utils.extend(new BaseFactory({}, ->), @factories[name])
    factory = utils.extend(factory, attrs)
    @_evaluateLazyAttributes factory, ->
      factory.initializeWith(factory, callback)

  create: (name, attrs = {}, callback) ->
    if typeof attrs == 'function'
      callback = attrs

    factory = utils.extend(new BaseFactory({}, ->), @factories[name])
    factory = utils.extend(factory, attrs)
    @_evaluateLazyAttributes factory, ->
      factory.createWith(factory, callback)

  _evaluateLazyAttributes: (factory, callback) ->
    lazyFunctions = []

    for prop of factory
      if factory.hasOwnProperty(prop) && typeof factory[prop] == 'function' && prop not in reservedProperties
        lazyFunctions.push(field: prop, func: factory[prop])

    if lazyFunctions.length
      utils.series(factory, lazyFunctions, callback)
    else
      callback()

exports.Factory = Factory
