extend = (source, object) ->
  for prop of object
    source[prop] = object[prop] if object.hasOwnProperty(prop)
  source

series = (binding, callbacks, last) ->
  next = ->
    callback = callbacks.shift()
    if callback
      callback.func.call binding, ->
        binding[callback.field] = arguments[1]
        next()
    else
      last()
  next()

capitalize = (string) ->
  string.charAt(0).toUpperCase() + string.slice(1)

toUnderscore = (string) ->
  string.replace /([A-Z])/g, ($1) -> "_" + $1.toLowerCase()

exports.extend = extend
exports.series = series
exports.capitalize = capitalize
exports.toUnderscore = toUnderscore