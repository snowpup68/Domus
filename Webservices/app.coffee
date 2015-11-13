db = (require 'mongojs') 'realtor', ['urls', 'residences']
fs = require 'fs'
async = require "async"
cheerio = require "cheerio"
request = require 'request'

{ Residence } = require "./modules/residence"

db.urls.distinct "url", {}, (error, urls) ->
    tasks = urls.map (url) ->
        (callback) ->
            request url, (error, response, html) ->
                residence = new Residence url
                residence.loadSync cheerio.load html
                residence.save db.residences, callback

    async.parallel tasks, (err) ->
        db.close()