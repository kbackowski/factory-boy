class BaseFactory
  constructor: (@name, @options = {}, callback) ->
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


Factory =
  factories: {}

  define: (name, options, callback) ->
    @factories[name] = new BaseFactory(name, options, callback)

  build: (name, attrs = {}) ->
    factory = @extend({}, @factories[name])
    factory = @extend(factory, attrs)
    factory.initialize()

  create: (name, attrs = {}, callback) ->
    if typeof attrs == 'function'
      callback = attrs

    factory = @extend({}, @factories[name])
    factory = @extend(factory, attrs)
    factory.create(callback)

  extend: (source, object) ->
    for prop of object
      source[prop] = object[prop]
    source

exports.Factory = Factory
