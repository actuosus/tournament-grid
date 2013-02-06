###
 * Stage
 * @author: actuosus
 * @fileOverview 
 * Date: 06/02/2013
 * Time: 05:14
###

Stage = require('../../models').Stage

exports.list = (req, res)->
  query = Stage.find({})
  query.where('_id').in(req.query?.ids) if req.query?.ids
  query.exec (err, docs)-> res.send stages: docs

exports.item = (req, res)->
  Stage.where('_id', req.params._id).findOne().exec (err, doc)->
    res.send stage: doc