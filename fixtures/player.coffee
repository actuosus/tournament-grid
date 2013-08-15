###
 * player
 * @author: actuosus
 * @fileOverview 
 * Date: 29/01/2013
 * Time: 17:49
###

Faker = require('../lib/Faker')
countries = require('./country').Country

players = [
  _id: '5107d4cd351fb19719000002'
  nickname: 'LeX'
  first_name: 'Алексей'
  last_name: 'Колесников'
  country_id: '50fcdaf969f206c106000001'
  team_id: '5107cac6c97716ba1800001d'
,
  _id: '5107d4cd351fb19719000003'
  nickname: 'evil'
  first_name: ''
  last_name: ''
  country_id: '50fcdaf969f206c106000009'
  team_id: '5107cac6c97716ba1800001d'
,
  _id: '5107d4cd351fb19719000004'
  nickname: 'kucher'
  first_name: 'Эмиль'
  last_name: 'Ахундов'
  country_id: '50fcdaf969f206c106000009'
  is_captain: yes
  team_id: '5107cac6c97716ba1800001d'
,
  _id: '5107d4cd351fb19719000005'
  nickname: 'hooch'
  first_name: ''
  last_name: ''
  country_id: '50fcdaf969f206c106000001'
  team_id: '5107cac6c97716ba1800001d'
,
  _id: '5107d4cd351fb19719000006'
  nickname: 'xaoc'
  first_name: ''
  last_name: ''
  country_id: '50fcdaf969f206c106000009'
  team_id: '5107cac6c97716ba1800001d'
,
  _id: '5107d4cd351fb19719000007'
  nickname: 'verYlOngPlayerNameForTesting'
  first_name: 'verYlOngPlayerFirstNameForTesting'
  last_name: 'verYlOngPlayerLastNameForTesting'
  country_id: '514569cef9bbb58f3100001a'
  team_id: '5116163383cf2f2534000002'
,
  _id: '5107d4cd351fb19719000008'
  nickname: 'sneg1'
  first_name: 'Антон'
  last_name: 'Антон'
  country_id: '50fcdaf969f206c106000001'
  team_id: '5107cac6c97716ba1800001d'
,
  nickname: 'fnatic'

]

for i in [0..Faker.Helpers.randomNumber(200)]
  players.push {
    nickname: Faker.Internet.userName()
    first_name: Faker.Name.firstName()
    last_name: Faker.Name.lastName()
    country_id: countries[Faker.Helpers.randomNumber(countries.length)]._id
    link: "http://#{Faker.Internet.domainName()}/"
  }

module.exports.Player = players
