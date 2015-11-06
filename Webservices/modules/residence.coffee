class @Residence
  constructor: (@url) ->
    @id = (@url.match /_(M[0-9]+-[0-9]+)$/)[1]
    @type = "all"

  getId: () -> @id

  getURL: () -> @url

  getCachePath: (path, ext) -> "#{path}#{@id}#{ext}"

  save: ->
    console.log "save #{@type} #{@url}"
