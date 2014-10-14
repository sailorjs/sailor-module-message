## -- Dependencies --------------------------------------------------------

path = "http://localhost:1337"

query_generator = (collection, query) ->
  if query? then "#{path}/#{collection}/#{query}" else "#{path}/#{collection}"

## -- Private -------------------------------------------------------------

url =
  user:
    create  : (query=undefined) ->  query_generator('user', query)
    update  : (query=undefined) ->  query_generator('user', query)
    find    : (query=undefined) ->  query_generator('user', query)
    destroy : (query=undefined) ->  query_generator('user', query)

  message:
    create  : (query=undefined) ->  query_generator('message', query)
    update  : (query=undefined) ->  query_generator('message', query)
    find    : (query=undefined) ->  query_generator('message', query)
    destroy : (query=undefined) ->  query_generator('message', query)

## -- Exports -------------------------------------------------------------

module.exports = url
