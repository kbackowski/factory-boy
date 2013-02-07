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


Factory =
  factories: {}

  define: (name, options, callback) ->
    @factories[name] = new BaseFactory(name, options, callback)

  build: (name, attrs = {}) ->
    factory = @factories[name]
    @extend(factory, attrs)
    factory.initialize()

  extend: (source, object) ->
    for prop of object
      source[prop] = object[prop]

exports.Factory = Factory
