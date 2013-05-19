###
 * application
 * @author: actuosus
 * Date: 13/05/2013
 * Time: 08:20
###

describe 'App', ->
  it 'should load report when ready', ->
#    App.report.get('stages')
    console.log App.get('report')
    App.get('report.isLoaded').should.be.true
