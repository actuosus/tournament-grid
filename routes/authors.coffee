###
 * authors
 * @author: actuosus
 * Date: 29/03/2013
 * Time: 04:06
###

User = require('../models').User
Report = require('../models').Report

exports.list = (req, res)->
  User.find({}).sort('name').exec (err, docs)->
    res.render 'authors/list.ect', title: 'Authors', docs: docs

exports.item = (req, res)->
  User.findById(req.params._id)
    .exec (err, doc)->
      Report.find({author: req.params._id}).exec (err, reports)->
        res.render 'authors/item.ect', title: 'Author', doc: doc, reports: reports