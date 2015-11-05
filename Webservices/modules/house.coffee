{ Residence } = require './residence'

class @House extends Residence
  constructor: (url) ->
    super
    @type = 'house'