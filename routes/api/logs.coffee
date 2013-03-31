###
 * logs
 * @author: actuosus
 * Date: 29/03/2013
 * Time: 02:32
###

Log = require('../../models').Log

exports.create = (req, res)->
  if req.body?.logs
    logs = []
    for log, i in req.body.logs
      console.log log, i
      l = new Log log
      await l.save defer err, logs[i]
      console.log logs
    res.send logs: logs
  else if req.body?.log
    log = req.body?.log
    l = new Log log
    await l.save defer err, doc
    res.send log: doc
  else
    res.send 500, error: "server error"