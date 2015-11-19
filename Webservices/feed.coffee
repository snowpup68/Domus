feedRead = require 'feed-read'

url = 'http://www.musicboxtheatre.com/feeds/all'

feedRead url, (err, articles) ->
  throw err if err

  console.log articles
