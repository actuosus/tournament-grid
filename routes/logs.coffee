###
 * logs
 * @author: actuosus
 * Date: 29/03/2013
 * Time: 02:46
###

Log = require('../models').Log

exports.list = (req, res)->
  Log.find({}).sort('date').exec (err, docs)->
    res.render 'logs/list.ect', title: 'Logs', docs: docs

exports.item = (req, res)->
  Log.findById(req.params._id)
    .exec (err, doc)->
      res.render 'logs/item.ect', title: 'Log', doc: doc