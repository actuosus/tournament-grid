###
 * rounds
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 14:26
###

Round = require('../../models').Round

exports.list = (req, res)-> Round.find({}).exec (err, docs)-> res.send rounds: docs
exports.item = (req, res)->
  Round.where('_id', req.params._id).findOne().exec (err, doc)->
    res.send round: doc