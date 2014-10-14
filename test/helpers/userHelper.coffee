## -- Dependencies ------------------------------------------------------

async   = require 'async'
request = require 'superagent'
url     = require './urlHelper'

## -- Class -------------------------------------------------------------

class UserHelper

  constructor: ->
    @_count = 0

  setCounter: (n) ->
    @_count = n

  generate: ->
    @_count++
    username: "user#{@_count}"
    email: "user#{@_count}@sailor.com"
    password: "password"

  register:(n=1, cb) ->
    _register = (c) => request.post(url.user.create()).send(@generate()).end(c)
    exec = []
    exec.push _register for i in [1..n]
    async.parallel(exec, -> cb())

## -- Exports -----------------------------------------------------------

module.exports = exports = new UserHelper()
