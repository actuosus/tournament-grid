###
 * multitran
 * @author: actuosus
 * Date: 21/03/2013
 * Time: 00:57
###

superagent = require 'superagent'
cheerio = require 'cheerio'

class MultitranTranslator
  serviceURL: 'http://www.multitran.ru/c/m.exe'

  supportedLanguages: ['ru', 'en']

  translate: (source, target, text, cb)->
    if source in @supportedLanguages
      sourceLanguageCode = @supportedLanguages.indexOf(source) + 1
    if target in @supportedLanguages
      targetLanguageCode = @supportedLanguages.indexOf(source) + 1
    superagent.get(@serviceURL)
    .query 'l1', sourceLanguageCode
    .query 'l2', targetLanguageCode
    .query 's', text
    .send (res)=> cb @parse(res.body)

  parse: (content)->
    $ = cheerio.load content
    data = []
    $('table td > a[href~="m.exe?"]').each (i, item)-> data.push item.text()
    data
