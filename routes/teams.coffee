###
 * teams
 * @author: actuosus
 * Date: 20/04/2013
 * Time: 02:01
###

Team = require('../models').Team

exports.list = (req, res)->
  Team.find({}).sort('name').exec (err, docs)->
    res.render 'teams/list.ect', title: 'Teams', docs: docs

exports.item = (req, res)->
  Team.findById(req.params._id)
    .populate('author')
    .populate('country_id')
    .exec (err, doc)->
      res.render 'teams/item.ect', title: 'Team', doc: doc

exports.createForm = (req, res)->
  res.render 'teams/form.ect', title: 'Team', doc: {}

exports.create = (req, res)->
  console.log req.body
  if req.body.title
    report = new Team req.body
    report.author = req.user
    report.save (err, doc)->
      if err
        res.render 'teams/form.ect', title: 'Team', doc: req.body
      else
        res.redirect "/teams/#{doc.id}"
  else
    res.render 'teams/form.ect', title: 'Team', doc: req.body