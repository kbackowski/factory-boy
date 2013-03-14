utils = require('./utils')

reservedProperties = ['options', 'createWith', 'initializeWith']

class BaseFactory
  constructor: (@options = {}, callback) ->
    callback.call(@)
    @

  association: (name, options = {}) ->
    factoryOptions = options.factory || {}
    factoryName = factoryOptions.name || name

    @["#{name}_id"] = (callback) ->
      Factory.create factoryName, options, (err, object) ->
        callback(err, object.id)

  traits: ->

  before: ->

  after: ->

Factory =
  factories: {}

  define: (name, options, callback) ->
    if typeof options == 'function'
      callback = options
      options = {}

    @factories[name] = new BaseFactory(options, callback)

  build: (name, attrs = {}, callback) ->
    if typeof attrs == 'function'
      callback = attrs

    factory = utils.extend(new BaseFactory({}, ->), @factories[name])
    factory = utils.extend(factory, attrs)
    @_evaluateLazyAttributes factory, =>
      factory.initializeWith?(factory.options.class, factory, callback) || @initializeWith(factory.options.class, factory, callback)

  create: (name, attrs = {}, callback) ->
    if typeof attrs == 'function'
      callback = attrs

    factory = utils.extend(new BaseFactory({}, ->), @factories[name])
    factory = utils.extend(factory, attrs)
    @_evaluateLazyAttributes factory, =>
      factory.createWith?(factory.options.class, factory, callback) || @createWith(factory.options.class, factory, callback)

  initializeWith: (klass, attributes, callback) ->
    callback(null, new klass(attributes))

  createWith: (klass, attributes, callback) ->
    klass.create(attributes, callback)

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
