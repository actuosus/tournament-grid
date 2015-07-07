User = require('../models').User
Report = require('../models').Report

exports.list = (req, res)->
  User.find({}).sort('name').exec (err, docs)->
    res.render 'users/list.ect', title: 'Authors', docs: docs

exports.profile = (req, res)->
  User.findById(req.params._id)
  .exec (err, doc)->
    Report.find({author: req.params._id}).exec (err, reports)->
      res.render 'users/profile.ect', title: 'Author', doc: doc, reports: reports