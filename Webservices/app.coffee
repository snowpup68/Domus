request = require 'request'
Promise = require 'promise'
cheerio = require "cheerio"
fs = require 'fs'

{ House } = require "./modules/house"

urls = [
  "http://www.realtor.com/realestateandhomes-detail/3218-N-Halsted-St-Apt-3S_Chicago_IL_60657_M78361-29752"
  #"http://www.realtor.com/realestateandhomes-detail/739-W-Aldine-Ave-Apt-4_Chicago_IL_60657_M85192-91208"
  #"http://www.realtor.com/realestateandhomes-detail/420-W-Belmont-Ave-Apt-22F_Chicago_IL_60657_M89866-78460"
  #"http://www.realtor.com/realestateandhomes-detail/555-W-Cornelia-Ave-Apt-1205_Chicago_IL_60657_M84700-65530"
]

items = (new House url for url in urls)

# get all files which are not present n the cache
[path, ext] = ["./data/", ".html"]
promises = items.filter (item) -> not fs.existsSync "#{path}#{item.getId()}#{ext}"
  .map (item) ->
    new Promise (resolve) ->
      request item
        .pipe fs.createWriteStream "#{path}#{item.getId()}#{ext}"
        .on 'finish', () -> resolve item

Promise.all promises
  .then () ->
    # process cached files
    items.map (item) ->
      new Promise (resolve, reject) ->
        fs.readFile "#{path}#{item.getId()}#{ext}", (error, html) ->
          if error
            reject error
          else
            item.load cheerio.load html
            resolve item
  .then (values) ->
    Promise.all values
      .then () ->
        console.log items
