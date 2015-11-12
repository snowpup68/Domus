class @Residence
  constructor: (url) ->
    @props = {}
    @props.url = url
    @props.mlsid = (url.match /_(M[0-9]+-[0-9]+)$/)[1]
    @props.price = 0

  getId: () -> @props.mlsid
  getURL: () -> @props.url
  getPrice: () -> @props.price

  loadSync: ($) ->
    props = @props
    pattern = /[^a-zA-Z0-9#]/g

    props[($ item).attr('itemprop')] = ($ item).text() for item in ($ '.property-caption').find 'span[itemprop]'

    props[item.children[0].children[0].data.toLowerCase().replace pattern, '_'] = item.children[1].children[0].data for item in ($ '#GeneralInfo').find 'li'

    ($ 'h3.title-section-sub').next('ul').find('li').map (i, item) ->
      [name, value] = ($ item).text().split ':'
      props[name.toLowerCase().replace pattern, '_'] = value.trim() if value?

    delete props[name] for name in ['seller']

  save: (collection, callback) ->
    props = @props
    collection.find {mlsid: props.mlsid, price: props.price}, (err, items) ->
      if items.length <= 0
        collection.save props, (err, saved) ->
          callback()
      else
        callback()
