db = (require 'mongojs') 'realtor', ['residences']
fs = require 'fs'
async = require "async"
cheerio = require "cheerio"
request = require 'request'

{ Residence } = require "./modules/residence"

urls = [
  "http://www.realtor.com/realestateandhomes-detail/3218-N-Halsted-St-Apt-3S_Chicago_IL_60657_M78361-29752"
  "http://www.realtor.com/realestateandhomes-detail/739-W-Aldine-Ave-Apt-4_Chicago_IL_60657_M85192-91208"
  "http://www.realtor.com/realestateandhomes-detail/420-W-Belmont-Ave-Apt-22F_Chicago_IL_60657_M89866-78460"
  "http://www.realtor.com/realestateandhomes-detail/555-W-Cornelia-Ave-Apt-1205_Chicago_IL_60657_M84700-65530"
  "http://www.realtor.com/realestateandhomes-detail/569-Mountain-Vista-Cir_Steamboat-Springs_CO_80487_M10249-35321"
  "http://www.realtor.com/realestateandhomes-detail/2270-Storm-Meadows-Unit-440-Dr-Unit-Bldga_Steamboat-Springs_CO_80487_M20606-53140"
  "http://www.realtor.com/realestateandhomes-detail/277-River-Rd_Steamboat-Springs_CO_80487_M27332-60450"
]

items = (new Residence url for url in urls)

[path, ext] = ["./data/", ".html"]

# get all files which are not present n the cache
fileTasks = items.filter (item) -> not fs.existsSync "#{path}#{item.getId()}#{ext}"
  .map (item) ->
    (callback) ->
      request item
        .pipe fs.createWriteStream "#{path}#{item.getId()}#{ext}"
        .on 'finish', () -> callback()

async.parallel fileTasks, (err, results) ->
  loadTasks = items.map (item) ->
    (callback) ->
      fs.readFile "#{path}#{item.getId()}#{ext}", (error, html) ->
        item.load cheerio.load html
        db.residences.save item, (err, saved) ->
          callback()

  async.parallel loadTasks, (err, results) ->
    db.close()
