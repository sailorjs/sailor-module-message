## -- Dependencies -----------------------------------------------------------------------

should    = require 'should'
request   = require 'superagent'
url       = require './helpers/urlHelper'
user      = require './helpers/userHelper'

## -- Test ------------------------------------------------------------------------------

describe "First Test :: /GET path", ->

  before (done) ->
    user.register(2, done)

  describe 'Message ::', ->

    describe '200 Created', ->

      it 'user1 sends message to user2', (done) ->
        request
        .post(url.create)
        .send
          to: 1
          from: 2
          text: 'hello world'
        .end (res) ->
          res.status.should.equal 201
          done()

    describe '400 badRequest', ->
      it 'try to send email without params', (done) ->
        request
        .post(url.create)
        .send()
        .end (res) ->
          res.status.should.equal 400
          done()

    describe '404 notFound', ->
      it 'provide users that dont exist', (done) ->
        request
        .post(url.create)
        .send
          to: 99
          from: 98
          text: 'hello world'
        .end (res) ->
          res.status.should.equal 404
          done()
