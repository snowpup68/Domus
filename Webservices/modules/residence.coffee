class @Residence
  constructor: (@url) ->
    @type = "all"

  save: ->
    console.log "save #{@type} #{@url}"
