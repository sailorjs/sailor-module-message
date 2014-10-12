path = "http://localhost:1337"

paths =
  # CRUD
  create:  path + "/message"
  update:  path + "/message"
  find:    path + "/message"
  destroy: path + "/message"

module.exports = paths
