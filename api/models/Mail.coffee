## -- Dependencies -------------------------------------------------------------

sailor = require 'sailorjs'
sort = sailor.util.sortKeys

## -- Exports -------------------------------------------------------------

module.exports =
  schema: true

  attributes:
    from    : type: 'integer', required: true
    to      : type: 'integer', required: true
    subject : type: 'string', required: true
    body    : type: 'string', required: true
    status  : type: 'string', enum: ['unread', 'read'], defaultsTo: 'unread'

    toJSON: (done) ->
      obj = @toObject()
      sort obj
