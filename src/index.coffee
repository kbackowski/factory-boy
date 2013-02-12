class BaseFactory
  constructor: (@options = {}, callback) ->
    @class = @options['class']
    callback.call(@)
    @

  traits: ->

  before: ->

  after: ->

  initialize: ->
    new @class(@)

  create: (callback) ->
    @class.create(@, callback)

  evaluateLazyAttributes: ->
    for prop of @
      if @hasOwnProperty(prop) && typeof @[prop] == 'function' && prop != 'class'
        @[prop] = @[prop]()


Factory =
  factories: {}

  define: (name, options, callback) ->
    @factories[name] = new BaseFactory(options, callback)

  build: (name, attrs = {}) ->
    factory = @extend(new BaseFactory({}, ->), @factories[name])
    factory = @extend(factory, attrs)
    factory.evaluateLazyAttributes()
    factory.initialize()

  create: (name, attrs = {}, callback) ->
    if typeof attrs == 'function'
      callback = attrs

    factory = @extend(new BaseFactory({}, ->), @factories[name])
    factory = @extend(factory, attrs)
    factory.evaluateLazyAttributes()
    factory.create(callback)

  extend: (source, object) ->
    for prop of object
      source[prop] = object[prop] if object.hasOwnProperty(prop)
    source

exports.Factory = Factory
