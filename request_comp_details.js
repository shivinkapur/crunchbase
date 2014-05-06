var http = require('http');
var Db = require('mongodb').Db,
    MongoClient = require('mongodb').MongoClient,
    Server = require('mongodb').Server,
    ReplSetServers = require('mongodb').ReplSetServers,
    ObjectID = require('mongodb').ObjectID,
    Binary = require('mongodb').Binary,
    GridStore = require('mongodb').GridStore,
    Grid = require('mongodb').Grid,
    Code = require('mongodb').Code,
    BSON = require('mongodb').pure().BSON,
    assert = require('assert');

function getData(url, callback) {
    var req = http.get(url, function(res) {
        res.setEncoding('utf8');
        var company_data = '';

        res.on('data', function(chunk) {
            company_data += chunk;
        });

        res.on('end', function() {
            var json_data = JSON.parse(company_data);
            var rel = json_data.data.relationships;
            for(var i in rel) {
                var url_i = rel[i].paging.first_page_url + "?user_key=f4c6f14f47ee61ff4bbb4686a4742dc4";
                getUrlData(url_i, function(data) {
                    console.log(data);
                });
            }
        });
    });
}

function getUrlData(url, callback) {
    var req = http.get(url, function(res) {
        res.setEncoding('utf8');
        var rel_data = '';
        res.on('data', function(chunk) {
            rel_data += chunk;
        });

        res.on('end', function() {
            var json_rel_data = JSON.parse(rel_data);
            callback(json_rel_data); 
        });
    });
}

var url = "http://api.crunchbase.com/v/2/organization/facebook?user_key=f4c6f14f47ee61ff4bbb4686a4742dc4";
getData(url, function() {
    console.log("Done.");
});