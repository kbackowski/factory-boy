utils = require('./utils')
FactoryBase = require('./factory_base')

initializeWith = (klass, attributes, callback) ->
  callback(null, new klass(attributes))

createWith = (klass, attributes, callback) ->
  klass.create(attributes, callback)

Factory =
  factories: {}

  define: (name, options = {}, callback) ->
    throw Error("Missing class parameter") unless options.class
    @_defineFactory(name, options, callback)

  build: (name, attrs = {}, callback) ->
    if typeof attrs == 'function'
      callback = attrs

    factory = utils.extend(new FactoryBase, @_fetchFactory(name))
    factory = utils.extend(factory, attrs)
    @_evaluateLazyAttributes factory, =>
      initializeMethod = factory.initializeWith || @initializeWith
      initializeMethod(factory.options.class, factory.attributes(), callback)

  create: (name, attrs = {}, callback) ->
    if typeof attrs == 'function'
      callback = attrs

    factory = utils.extend(new FactoryBase, @_fetchFactory(name))
    factory = utils.extend(factory, attrs)
    @_evaluateLazyAttributes factory, =>
      createMethod = (factory.createWith || @createWith)
      createMethod(factory.options.class, factory.attributes(), callback)

  reload: ->
    @createWith = createWith
    @initializeWith = initializeWith
    @factories = {}

  _evaluateLazyAttributes: (factory, callback) ->
    lazyFunctions = []

    for prop of factory.lazyProperties()
      lazyFunctions.push(field: prop, func: factory[prop])

    if lazyFunctions.length
      utils.series(factory, lazyFunctions, callback)
    else
      callback()

  _defineFactory: (name, options, callback) ->
    throw Error("Factory already defined: #{name}") if @factories[name]
    @factories[name] = new FactoryBase(options, callback)

  _fetchFactory: (name) ->
    @factories[name] || throw Error("Factory not defined: #{name}")

Factory.reload()

module.exports = Factory