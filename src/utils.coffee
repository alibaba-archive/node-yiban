superagent = require('superagent')

module.exports = (method, uri, data, callback) ->
  url = "#{config.HOST}#{uri}"

  if typeof data is 'function'
    callback = data
    data = null

  sa = superagent[method](url)
  sa.set('User-Agent', 'SuperAgent')
  sa.set('X-Requested-With', 'XMLHttpRequest')
  sa.set('Authorization', "OAuth2 #{token}")
  sa.send(data) if data
  sa.end(callback)