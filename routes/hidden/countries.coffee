###
 * countries
 * @author: actuosus
 * Date: 16/06/2013
 * Time: 01:19
###

Country = require('../../models').Country

exports.create = (req, res)->
  if req.body?.country
    country = req.body.country
    c = new Country country
    await c.save defer err, doc
    res.send country: doc

exports.update = (req, res)->
  if req.body?.country
    country = req.body.country
    await Country.findByIdAndUpdate req.params._id, {$set: country}, defer err, doc
    res.send country: doc
  else
    res.send 400, error: "server error"

exports.delete = (req, res)->
  Country.findByIdAndRemove req.params._id, (err)->
    res.status 204 unless err
    res.send()
