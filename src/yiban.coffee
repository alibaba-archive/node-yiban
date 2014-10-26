request = require('request')

class Yiban

  name: 'yiban'
  host: 'https://openapi.yiban.cn'
  client_id: 'set_client_id'
  client_secret: 'set_client_secret'
  authorize_uri: "/oauth/authorize"
  access_token_uri: "/oauth/access_token"
  redirect_uri: "http://example.com/yiban/callback"

  constructor: (client_id, client_secret, redirect_uri) ->
    @client_id = client_id
    @client_secret = client_secret
    @redirect_uri = redirect_uri

  getAccessToken: (code, callback) ->
    self = @
    request
      url:  "#{@host}#{@access_token_uri}"
      method: 'POST'
      form:
        client_id: @client_id
        client_secret: @client_secret
        code: code
        redirect_uri: @redirect_uri
    , (err, res, body) ->
      json = res.toJSON()
      if json.statusCode is 302
        request.get json.headers.location, (err, res, body) ->
          try
            ret = JSON.parse(body)
            self.access_token = ret.access_token
          catch e
            ret = {}
          callback(err, ret)
      else callback(err)

  getAuthorizeUrl: ->
    qs =
      client_id: @client_id
      redirect_uri: encodeURIComponent(@redirect_uri)
      display: 'web'

    authorizeUrl = "#{@host}#{@authorize_uri}?"
    for key, val of qs
      authorizeUrl += "#{key}=#{val}&"
    authorizeUrl

  api: (uri, callback) ->
    request.get "#{@host}#{uri}?access_token=#{@access_token}", (err, res, body) ->
      callback(err, JSON.parse(body))

  oauth: (options = {}) ->
    self = @

    (req, res, next) ->
      if req.path is options.authorize_uri
        return res.redirect(self.getAuthorizeUrl())
      else if req.path is options.redirect_uri
        code = req.query.code
        self.getAccessToken code, (err, ret) ->
          if options.callback
            options.callback(err, res, ret)
          else res.json(err or ret)
      else next()

module.exports = Yiban
