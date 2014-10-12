###
Dependencies
###
sailor     = require 'sailorjs'
actionUtil = sailor.actionUtil
translate  = sailor.translate
validator  = sailor.validator
errorify   = sailor.errorify

###
Create Record

post /:modelIdentity

An API call to find and return a single model instance from the data adapter
using the specified criteria.  If an id was specified, just the instance with
that unique id will be returned.

Optional:
@param {String} callback - default jsonp callback param (i.e. the name of the js function returned)
@param {*} * - other params will be used as `values` in the create
###
module.exports = (req, res) ->
  req.assert('from', translate.get "Message.From.NotFound").notEmpty()
  req.assert('to', translate.get "Message.To.NotFound").notEmpty()
  req.assert('text', translate.get "Message.Text.NotFound").notEmpty()
  return res.badRequest(errorify.serialize(req)) if req.validationErrors()

  from     = req.param 'from'
  to       = req.param 'to'
  text     = req.param 'text'

  User.findOne(from).exec (err, user) ->
    return res.badRequest(err)  if err

    User.findOne(to).exec (err, friend) ->
      return res.badRequest(err)  if err

      unless user and friend and text
        errors = []
        errorify.addError(errors, 'from', translate.get("Model.NotFound")) unless user
        errorify.addError(errors, 'to', translate.get("Model.NotFound")) unless friend
        errorify.addError(errors, 'text', 'NO TEXT') unless text
        return res.notFound(errorify.serialize(errors))

      message =
        from: user.id
        to: friend.id
        text: text

      Message.create(message).exec (err, newInstance) ->
        return res.negotiate(err)  if err

        ## TODO: Put in the inbox of user in the correct collection

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
