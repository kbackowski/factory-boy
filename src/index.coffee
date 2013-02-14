class BaseFactory
  constructor: (@options = {}, callback) ->
    @class = @options['class']
    callback.call(@)
    @

  traits: ->

  before: ->

  after: ->

  initializeWith: (attributes, callback) ->
    callback(null, new @class(attributes))

  createWith: (attributes, callback) ->
    @class.create(attributes, callback)

  evaluateLazyAttributes: (callback) ->
    lazyFunctions = []

    for prop of @
      if @hasOwnProperty(prop) && typeof @[prop] == 'function' && prop not in ['class', 'createWith', 'initializeWith']
        lazyFunctions.push(field: prop, func: @[prop])

    if lazyFunctions.length
      @series(lazyFunctions, callback)
    else
      callback()

  series: (callbacks, last) ->
    binding = @
    
    next = ->
      callback = callbacks.shift()
      if callback
        callback.func.call binding, ->
          binding[callback.field] = arguments[1]
          next()
      else
        last()
    next()

Factory =
  factories: {}

  define: (name, options, callback) ->
    @factories[name] = new BaseFactory(options, callback)

  build: (name, attrs = {}, callback) ->
    if typeof attrs == 'function'
      callback = attrs

    factory = @extend(new BaseFactory({}, ->), @factories[name])
    factory = @extend(factory, attrs)
    factory.evaluateLazyAttributes ->
      factory.initializeWith(factory, callback)

  create: (name, attrs = {}, callback) ->
    if typeof attrs == 'function'
      callback = attrs

    factory = @extend(new BaseFactory({}, ->), @factories[name])
    factory = @extend(factory, attrs)
    factory.evaluateLazyAttributes ->
      factory.createWith(factory, callback)

  extend: (source, object) ->
    for prop of object
      source[prop] = object[prop] if object.hasOwnProperty(prop)
    source

exports.Factory = Factory
