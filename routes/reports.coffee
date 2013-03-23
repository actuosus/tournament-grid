###
 * reports
 * @author: actuosus
 * Date: 18/03/2013
 * Time: 20:41
###

Report = require('../models').Report

exports.list = (req, res)->
  Report.find({}).sort('name').exec (err, docs)->
    res.render 'reports/list.ect', title: 'Reports', docs: docs

exports.item = (req, res)->
  Report.findById(req.params._id)
  .populate('author')
  .exec (err, doc)->
    res.render 'reports/item.ect', title: 'Report', doc: doc
