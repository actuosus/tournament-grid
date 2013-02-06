###*
 * fixtures
 * @author: actuosus
 * @fileOverview 
 * Date: 01/09/2012
 * Time: 23:39
###

#Dependencies
fs = require 'fs'
mongoose = require 'mongoose'

###*
* Clears a collection and inserts the given data as new documents
*
* @param {Mixed}       The data to load. This parameter accepts either:
*                          String: Path to a file or directory to load
*                          Object: Object literal in the form described above
* @param {Connection}  [db] Optionally, the mongoose connection to use.
*                           Defaults to mongoose.connection.
* @param {Function}    Callback
###
load = exports.load = (data, db, callback)->
  if typeof db is 'function'
    callback = db
    db = mongoose.connection
  if typeof data == 'object'
    loadObject data, db, callback
  else if typeof data is 'string'
    #Get the absolute dir path if a relative path was given
    if data.substr(0, 1) isnt '/'
      parentPath = module.parent.filename.split '/'
      parentPath.pop()
      data = parentPath.join('/') + '/' + data

    #Determine if data is pointing to a file or directory
    fs.stat data, (err, stats)->
      throw err if err
      if stats.isDirectory()
        loadDir data, db, callback
      else #File
        loadFile data, db, callback
  else #Unsupported type
    callback new Error 'Data must be an object, array or string (file or dir path)'

###*
* Clears a collection and inserts the given data as new documents
*
* @param {String}      The name of the model e.g. User, Post etc.
* @param {Object}      The data to insert, as an array or object. E.g.:
*                          { user1: {name: 'Alex'}, user2: {name: 'Bob'} }
*                      or:
*                          [ {name: 'Alex'}, {name:'Bob'} ]
* @param {Connection}  The mongoose connection to use
* @param {Function}    Callback
###
insertCollection = (modelName, data, db, callback)->
  callback = callback || {}

  #Counters for managing callbacks
  tasks = total: 0, done: 0

  #Load model
  Model = db.model modelName

  #Clear existing collection
#  console.log Model.collection
  Model.collection.remove (err)-> callback err if err

  #Convert object to array
  items = []
  if Array.isArray data
    items = data
  else
    items.push item for item in data

  #Check number of tasks to run
  if items.length is 0
    return callback()
  else
    tasks.total = items.length

  #Insert each item individually so we get Mongoose validation etc.
  items.forEach (item)->
    doc = new Model item
    doc.save (err)->
      callback(err) if err

      #Check if task queue is complete
      tasks.done++
      callback() if tasks.done == tasks.total


###*
* Loads fixtures from object data
*
* @param {Object}      The data to load, keyed by the Mongoose model name e.g.:
*                          { User: [{name: 'Alex'}, {name: 'Bob'}] }
* @param {Function}    Callback
###
loadObject = (data, db, callback)->
  callback = callback || ()->

    #Counters for managing callbacks
  tasks = total: 0, done: 0
  #Go through each model's data
  for modelName, values of data
    (()->
      tasks.total++

      insertCollection modelName, data[modelName], db, (err)->
        throw err if err
        tasks.done++
        callback() if tasks.done is tasks.total
    )()


###*
* Loads fixtures from one file
*
* TODO: Add callback option
*
* @param {String}      The full path to the file to load
* @param {Function}    Callback
###
loadFile = (file, db, callback)->
  callback = callback || ()->

  if file.substr(0, 1) isnt '/'
    parentPath = module.parent.filename.split '/'
    parentPath.pop()
    file = parentPath.join('/') + '/' + file
  load require(file), db, callback


###*
* Loads fixtures from all files in a directory
*
* TODO: Add callback option
*
* @param {String}      The directory path to load e.g. 'data/fixtures' or '../data'
* @param {Function}    Callback
###
loadDir = (dir, db, callback)->
  callback = callback || ()->

    #Get the absolute dir path if a relative path was given
  if dir.substr(0, 1) isnt '/'
    parentPath = module.parent.filename.split '/'
    parentPath.pop()
    dir = parentPath.join('/') + '/' + dir

  #Counters for managing callbacks
  tasks = total: 0, done: 0

  #Load each file in directory
  fs.readdir dir, (err, files)->
    return callback err if err
    tasks.total = files.length
    files.forEach (file)->
      loadFile dir + '/' + file, db, (err)->
        return callback(err) if err

        tasks.done++
        callback() if tasks.total == tasks.done
