## -- Dependencies -----------------------------------------------------------------------

should  = require 'should'
request = require 'superagent'
url     = require './helpers/urlHelper'
user    = require './helpers/userHelper'

## -- Test ------------------------------------------------------------------------------

describe "Message ::", ->

  before (done) ->
    user.register(2, done)

  describe 'created :: POST /message', ->
    describe '201 Created', ->
      it 'user1 sends message to user2', (done) ->
        request
        .post(url.message.create())
        .send
          to: 1
          from: 2
          text: 'hello world'
        .end (res) ->
          res.status.should.equal 201
          done()

      it 'user1 sends message to user2 with status read', (done) ->
        request
        .post(url.message.create())
        .send
          to: 1
          from: 2
          text: 'hello world'
          status: 'read'
        .end (res) ->
          res.body.status.should.eql 'read'
          res.status.should.equal 201
          done()

    describe '400 badRequest', ->
      it 'try to send email without params', (done) ->
        request
        .post url.message.create()
        .send()
        .end (res) ->
          res.status.should.equal 400
          done()

    describe '404 notFound', ->
      it 'provide users that dont exist', (done) ->
        request
        .post url.message.create()
        .send
          to: 99
          from: 98
          text: 'hello world'
        .end (res) ->
          res.status.should.equal 404
          done()

  describe 'find :: GET /message', ->
    describe '200 OK', ->
      it 'search message from an user', (done) ->
        request
        .get url.message.find()
        .end (res)->
          res.status.should.eql 200
          done()

    describe '404 notFound', ->
      it 'search message from an user that doesnt exist', (done) ->
        request
        .get url.message.find('9')
        .end (res)->
          res.status.should.eql 404
          done()

  describe 'update :: PUT /message', ->
    describe '200 OK', ->
      it 'change the status of a message', (done) ->
        request
        .put url.message.update('1')
        .send
          status: 'read'
        .end (res) ->
          res.status.should.equal 200
          res.body.status.should.eql 'read'
          done()

  describe 'destroy :: DELETE /message', ->
    describe '200 OK', ->
      it 'remove message', (done) ->
        request
        .del url.message.destroy('1')
        .end (res)->
          res.status.should.eql 200
          done()
