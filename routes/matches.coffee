###
 * matches
 * @author: actuosus
 * Date: 20/04/2013
 * Time: 01:58
###

Match = require('../models').Match

exports.list = (req, res)->
  Match.find({}).sort('name').exec (err, docs)->
    res.render 'matches/list.ect', title: 'Matches', docs: docs

exports.item = (req, res)->
  Match.findById(req.params._id)
    .populate('author')
    .populate('entrant1_id')
    .populate('entrant2_id')
    .exec (err, doc)->
      console.log doc
      res.render 'matches/item.ect', title: 'Match', doc: doc

exports.createForm = (req, res)->
  res.render 'matches/form.ect', title: 'Match', doc: {}

exports.create = (req, res)->
  console.log req.body
  if req.body.title
    report = new Match req.body
    report.author = req.user
    report.save (err, doc)->
      if err
        res.render 'matches/form.ect', title: 'Match', doc: req.body
      else
        res.redirect "/matches/#{doc.id}"
  else
    res.render 'matches/form.ect', title: 'Match', doc: req.body