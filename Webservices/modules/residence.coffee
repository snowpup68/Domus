class @Residence
  constructor: (@url) ->
    @id = (@url.match /_(M[0-9]+-[0-9]+)$/)[1]
    @type = "all"

  getId: () -> @id
  getURL: () -> @url

  load: ($) ->
    props = {}
    ($ 'span[itemprop]').map (i, item) ->
      props[($ item).attr('itemprop')] = ($ item).text()
    @props = props
    tabOverview = $ '#tab-overview'
    console.log tabOverview

  save: ->
    console.log "save #{@type} #{@url}"
