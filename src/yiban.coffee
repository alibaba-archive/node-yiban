superagent = require('superagent')

class Yiban

  name: 'yiban'
  host: 'https://openapi.yiban.cn'
  client_id: 'set_client_id'
  client_secret: 'set_client_secret'
  authorize_uri: "/oauth/authorize"
  access_token_uri: "/oauth/access_token"
  redirect_uri: "http://example.com/yiban/callback"

  constrcutor: (client_id, client_secret, redirect_uri) ->
    @client_id = client_id
    @client_secret = client_secret
    @redirect_uri = redirect_uri
    
  _request: (method, uri, data, callback) ->
    url = "#{@host}#{uri}"

    if typeof data is 'function'
      callback = data
      data = null

    sa = superagent[method](url)
    sa.set('User-Agent', 'Teambition Yiban/1')
    sa.set('X-Requested-With', 'XMLHttpRequest')
    sa.send(data) if data
    sa.end(callback)

  getAccessToken: (code, callback) ->

    @_request 'post', @access_token_uri, 
      client_id: @client_secret
      client_secret: @client_secret
      code: code
      redirect_uri: @redirect_uri
    , (err, res) -> callback err, res.body

  getAuthorizeUrl: ->
    qs =
      client_id: @client_id
      redirect_uri: encodeURIComponent(@redirect_uri)
      display: 'web'

    authorizeUrl = "#{@host}#{@authorize_uri}?"
    for key, val of qs
      authorizeUrl += "#{key}=#{val}&"
    authorizeUrl

module.exports = new Yiban
