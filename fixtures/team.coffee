###
 * team
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 10:00
###

Faker = require('../lib/Faker')
countries = require('./country').Country

teams = [
  _id: '50fcdf189c68d90f07000001',
  name: 'Umitara',
  country_id: '50fcdaf969f206c106000005'
  link: 'http://umi.ru'
,
  _id: '50fcdf189c68d90f07000002',
  name: 'Wikipediots',
  country_id: '50fcdaf969f206c106000004'
,
  _id: '50fcdf189c68d90f07000003',
  name: 'Stephano',
  country_id: '50fcdaf969f206c106000007'
,
  _id: '50fcdf189c68d90f07000004',
  name: 'Bly',
  country_id: '50fcdaf969f206c106000006'
,
  _id: '5116163383cf2f2534000002'
  name: 'Very long team name for testing purpose'
  country_id: '514569cef9bbb58f3100001a'
  players: ['5107d4cd351fb19719000007']
,
  name: 'Natus Vincere'
  country_id: '50fcdaf969f206c106000009'
,
  name: 'fnatic'
  country_id: '50fcdaf969f206c106000009'
,
  name: 'fnatic'
  country_id: '50fcdaf969f206c106000001'
,
  name: 'BGDonLINE'
  country_id: '50fcdaf969f206c106000001'
,
  name: 'Frag eXecutors'
  country_id: '50fcdaf969f206c106000001'
,
  name: 'ESC Gaming'
  country_id: '50fcdaf969f206c106000001'
,
  name: 'SK Gaming'
  country_id: '50fcdaf969f206c106000001'
,
  name: 'mTw'
  country_id: '50fcdaf969f206c106000001'
,
  name: 'mousesports'
  country_id: '50fcdaf969f206c106000008'#
,
  name: 'RG-Esports'
  country_id: '50fcdaf969f206c106000001'
,
  name: 'Moscow Five'
  country_id: '50fcdaf969f206c106000001'#
,
  name: 'iNation'
  country_id: '50fcdaf969f206c106000001'
,
  name: 'HEADSHOTBG'
  country_id: '50fcdaf969f206c106000001'
,
  name: 'Made in Brazil'
  country_id: '50fcdaf969f206c106000001'
,
  name: 'Anexis'
  country_id: '50fcdaf969f206c106000001'
,
  name: 'Evil Geniuses'
  country_id: '50fcdaf969f206c106000001'
,
  name: 'ESC Gaming.se'
  country_id: '50fcdaf969f206c106000001'
,
  name: 'WinFakt.fi'
  country_id: '50fcdaf969f206c106000001'
,
  name: 'Lions'
  country_id: '50fcdaf969f206c106000001'
,
  name: 'USSR'
  country_id: '50fcdaf969f206c106000001'#
,
  name: 'mTw.de'
  country_id: '50fcdaf969f206c106000008'#
,
  name: 'Alternate'
  country_id: '50fcdaf969f206c106000008'#
,
  name: 'TyLoo'
  country_id: '50fcdaf969f206c106000001'
,
  name: 'WeMade FOX'
  country_id: '50fcdaf969f206c106000001'
,
  name: 'Power Gaming'
  country_id: '50fcdaf969f206c106000001'
,
  name: 'DTS'
  country_id: '50fcdaf969f206c106000009'
,
  name: 'Cheap Times!'
  country_id: '50fcdaf969f206c106000001'
,
  name: 'x6tence'
  country_id: '50fcdaf969f206c106000001'
,
  _id: '5107cac6c97716ba1800001d'
  name: 'Virtus.pro'
  country_id: '50fcdaf969f206c106000001'#
  players: ['5107d4cd351fb19719000002', '5107d4cd351fb19719000003', '5107d4cd351fb19719000004', '5107d4cd351fb19719000005', '5107d4cd351fb19719000006', '5107d4cd351fb19719000008']
,
  name: 'n!faculty'
  country_id: '50fcdaf969f206c106000008'#
,
  name: 'TBH'
  country_id: '50fcdaf969f206c106000008'#
,
  name: 'ex-MYM'
  country_id: '50fcdaf969f206c106000001'
,
  name: 'KerchNET'
  country_id: '50fcdaf969f206c106000009'
,
  name: 'Millenium'
  country_id: '50fcdaf969f206c106000001'
,
  name: 'myRevenge.de'
  country_id: '50fcdaf969f206c106000008'#
,
  name: 'ydk.me'
  country_id: '50fcdaf969f206c106000008'#
,
  name: 'forZe'
  country_id: '50fcdaf969f206c106000001'#
,
  name: 'Playzone'
  country_id: '50fcdaf969f206c106000008'
,
  name: 'k1ck'
  country_id: '50fcdaf969f206c106000001'
,
  name: 'ESC Gaming.de'
  country_id: '50fcdaf969f206c106000008'#
,
  name: 'Frankfurt 69ers'
  country_id: '50fcdaf969f206c106000001'
,
  name: 'TeG'
  country_id: '50fcdaf969f206c106000001'
,
  name: '.no'
  country_id: '50fcdaf969f206c106000001'
,
  name: 'Hardware4u'
  country_id: '50fcdaf969f206c106000001'
,
  name: 'DELTA'
  country_id: '50fcdaf969f206c106000001'
,
  name: 'Tera-Gaming'
  country_id: '50fcdaf969f206c106000008'#
]

for i in [0..Faker.Helpers.randomNumber(200)]
  teams.push {
    name: Faker.Company.companyName()
    country_id: countries[Faker.Helpers.randomNumber(countries.length)]._id
    link: "http://#{Faker.Internet.domainName()}/"
  }

module.exports.Team = teams