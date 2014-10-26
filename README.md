node-yiban
==========

nodejs sdk for yiban

### Install
```
npm install yiban
```

### How to use
```

yiban = new Yiban(client_id, client_secret, redirect_uri)

code = http.redirect(yiban.getAuthorizeUrl())
access_token = yiban.getAccessToken(code, callback)

```
