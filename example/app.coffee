
express = require('express')
app = express()

Yiban = require('../src/yiban')

yiban = new Yiban(
  '53befd699673c8ab066f6a61bfa02de1',
  '5f8c75f3ace4830d2a91883858280623',
  'http://127.0.0.1:4000/yiban/callback'
)

app.use yiban.oauth({
  authorize_uri: '/yiban/auth'
  redirect_uri: '/yiban/callback'  
})
app.get '/', (req, res) ->
  res.send('yiban example')

app.get '*', (req, res) ->
  yiban.api req.path, (err, ret) ->
    res.json(ret)

app.listen(4000)
console.log 'Listening 4000'