###
 * stage
 * @author: actuosus
 * @fileOverview 
 * Date: 06/02/2013
 * Time: 11:50
###

module.exports.Stage = [
  _id: '51121246b54802daae000008'
  title: 'Отборочный'
  _title:
    ru: 'Отборочный'
    en: 'Qualification'
    de: 'Auswahlphase'
  description: 'Большая серия матчей с обилием команд'
  report_id: '511211b49709aab1ae000002'
  visual_type: 'matrix'
  rounds: ['51142b464242d3110c000025']
,
  _id: '51121246b54802daae000009'
  title: 'Групповой'
  _title:
    ru: 'Групповой'
    en: 'Group'
    de: 'Gruppenspiele'
  report_id: '511211b49709aab1ae000002'
  visual_type: 'group'
  rounds: ['5114472b6da8bd2910000002', '5114472b6da8bd2910000003', '5114472b6da8bd2910000004', '5114472b6da8bd2910000005', '5114472b6da8bd2910000006', '5114472b6da8bd2910000007']
,
  _id: '51121246b54802daae00000a'
  title: 'Single Elimination'
  _title:
    ru: 'Олимпийская система'
    en: 'Single Elimination'
    de: 'K.-o.-System'
  report_id: '511211b49709aab1ae000002'
  visual_type: 'single'
  entrants_number: '8'
  rounds: ['50fd4a58cbbf53a72a000002', '50fd4a58cbbf53a72a000003', '50fd4a58cbbf53a72a000004']
,
  _id: '51121246b54802daae00000c'
  title: 'Double Elimination'
  _title:
    ru: 'Двушка'
    en: 'Double Elimination'
    de: 'Doppel-K.-o.-System'
  report_id: '511211b49709aab1ae000002'
  visual_type: 'double'
  entrants_number: '64'
#  rounds: ['50fd4a58cbbf53a72a000002', '50fd4a58cbbf53a72a000003', '50fd4a58cbbf53a72a000004']
,
  _id: '51121246b54802daae00000b'
  title: 'Командный'
  _title:
    ru: 'Командный'
    en: 'Team'
    de: 'Team'
  visual_type: 'team'
  report_id: '511211b49709aab1ae000002'
  rounds: ['51142b464242d3110c000002']

,
  _id: '51121246b54802daae00000f'
  title: 'Игроки'
  visual_type: 'matrix'
  report_id: '511211b49709aab1ae000002'
]