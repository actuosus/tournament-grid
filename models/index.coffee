###
 * index
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 07:22
###

_ = require 'lodash'

coreModels = require './core'
extraModels = require './extra'

merged = _.extend coreModels, extraModels

module.exports = merged