class @Residence
  constructor: (@url) ->
    @id = (@url.match /_(M[0-9]+-[0-9]+)$/)[1]
    @type = "all"

  getId: () -> @id
  getURL: () -> @url

  load: ($) ->
    @props = {}
    @props[($ item).attr('itemprop')] = ($ item).text() for item in ($ '.property-caption span[itemprop]')
    @props[item.children[0].children[0].data.toLowerCase()] = item.children[1].children[0].data for item in($ '#GeneralInfo ul li')
    delete @props.seller

  save: ->
    console.log "save #{@type} #{@url}"
