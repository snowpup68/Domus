_ = require 'lodash'

{ House } = require './modules/house'

urls = [
  'http://www.realtor.com/realestateandhomes-detail/3218-N-Halsted-St-Apt-3S_Chicago_IL_60657_M78361-29752'
]

_.map urls, (item) ->
  console.log item

residence = new House 'http://www.yahoo.com'
residence.save()
