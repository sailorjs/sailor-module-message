## -- Dependencies -------------------------------------------------------------

sailor     = require 'sailorjs'
validator  = sailor.validator
actionUtil = sailor.actionUtil
translate  = sailor.translate
errorify   = sailor.errorify

## -- Exports -------------------------------------------------------------

module.exports =

  sendMessage: (req, res) ->
    from     = req.param 'from'
    to       = req.param 'to'
    text     = req.param 'text'

    User.findOne(from).exec (err, user) ->
      return res.badRequest(err)  if err

      User.findOne(to).exec (err, friend) ->
        return res.badRequest(err)  if err

        unless user and friend
          errors = []
          errorify.addError(errors, 'from', translate.get("Model.NotFound")) unless user
          errorify.addError(errors, 'to', translate.get("Model.NotFound")) unless friend
          return res.notFound(errorify.serialize(errors))

        message =
          from: user.id
          to: friend.id
          text: text

        Message.create(message).exec (err, newInstance) ->
          return res.negotiate(err)  if err

          # Use find method to return the model for the populate option
          Message.findOne(newInstance.id).populateAll().exec (err, newInstance) ->

            # If we have the pubsub hook, use the model class's publish method
            # to notify all subscribers about the created item
            if req._sails.hooks.pubsub
              if req.isSocket
                Message.subscribe req, newInstance
                Message.introduce newInstance
              Message.publishCreate newInstance, not req.options.mirror and req

            res.created newInstance
