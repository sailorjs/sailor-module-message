## -- Dependencies -----------------------------------------------------------------------

should    = require 'should'
request   = require 'superagent'
url       = require './helpers/urlHelper'
user      = require './helpers/userHelper'

## -- Test ------------------------------------------------------------------------------

describe "First Test :: /GET path", ->

  before (done) ->
    user.register(2, url.create, done)

  describe 'Message ::', ->

    it 'user1 sends message to user2', (done) ->
      request
      .post
