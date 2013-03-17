utils = require('./utils')

reservedProperties = ['association', 'options', 'createWith', 'initializeWith']

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

  traits: ->

  before: ->

  after: ->

Factory =
  factories: {}

  define: (name, options, callback) ->
    if typeof options == 'function'
      callback = options
      options = {}

    @factories[name] = new FactoryBase(options, callback)

  build: (name, attrs = {}, callback) ->
    if typeof attrs == 'function'
      callback = attrs

    factory = utils.extend(new FactoryBase({}, ->), @factories[name])
    factory = utils.extend(factory, attrs)
    @_evaluateLazyAttributes factory, =>
      factory.initializeWith?(factory.options.class, factory, callback) || @initializeWith(factory.options.class, factory, callback)

  create: (name, attrs = {}, callback) ->
    if typeof attrs == 'function'
      callback = attrs

    factory = utils.extend(new FactoryBase({}, ->), @factories[name])
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
exports.FactoryBase = FactoryBase
exports.utils = utils
