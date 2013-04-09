###
 * array
 * @author: actuosus
 * Date: 06/04/2013
 * Time: 21:04
###

define ->
  Array.prototype.intersect = ->
    ret = []
    obj = {}
    nOthers = arguments.length - 1
    nShortest = arguments[0].length
    shortest = 0
    for i in [0...nOthers]
      n = arguments[i].length
      if n < nShortest
        shortest = i
        nShortest = n

    for i in [0...nOthers]
      if i is shortest then n = 0 else n = (i or shortest)
      len = arguments[n].length
      for j in [0..len]
        elem = arguments[n][j]
        if obj[elem] is i - 1
          if i is nOthers
            ret.push elem
            obj[elem] = 0
          else
            obj[elem] = i
        else if i is 0
          obj[elem] = 0
    ret