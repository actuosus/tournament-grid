###
 * reports
 * @author: actuosus
 * Date: 18/03/2013
 * Time: 20:41
###

Report = require('../models').Report

exports.item = (req, res)->
  Report.findById(req.params.id)
    .exec (err, doc)->
      res.render 'report/item', title: 'Report', item: doc
