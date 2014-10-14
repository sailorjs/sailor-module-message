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
      it 'user1 have a new message in outbox', (done) ->
        request
        .get url.user.find('1')
        .end (res) ->
          res.status.should.equal 200
          res.body.inbox.should.eql 1
          res.body.outbox.should.eql 0
          done()

      it 'user2 have a new message in inbox', (done) ->
        request
        .get url.user.find('2')
        .end (res) ->
          res.status.should.equal 200
          res.body.inbox.should.eql 0
          res.body.outbox.should.eql 1
          done()

      it 'get the inbox message of a user', (done) ->
        request
        .get url.user.find('1/inbox')
        .end (res) ->
          res.status.should.equal 200
          res.body.length.should.eql 1
          done()

      it 'get the outbox message of a user', (done) ->
        request
        .get url.user.find('2/outbox')
        .end (res) ->
          res.status.should.equal 200
          res.body.length.should.eql 1
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
          request
          .get url.user.find('1/inbox')
          .end (res) ->
            res.status.should.equal 200
            res.body.length.should.eql 1
            done()

  describe 'destroy :: DELETE /message', ->
    describe '204 noContent', ->
      it 'remove message and remove from the inbox', (done) ->
        request
        .del url.message.destroy('1')
        .end (res) ->
          request
          .get url.message.find()
          .end (res) ->
            res.status.should.equal 204
            done()
