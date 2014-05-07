var async = require('async');
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

var json_data;

function getData(url, callback) {
    var req = http.get(url, function(res) {
        res.setEncoding('utf8');
        var company_data = '';

        res.on('data', function(chunk) {
            company_data += chunk;
        });

        res.on('end', function() {
            json_data = JSON.parse(company_data);
            var relation = json_data.data.relationships;

            var arr = [];
            for(var i in relation) {
                arr.push(i);
            }

            async.each(arr, function(rel, cb) {
                var url_i = relation[rel].paging.first_page_url + "?user_key=4f6fb15f3eb9187e1668d3d6604758d4";
                    
                var flag = false;
                getUrlData(url_i, rel, flag, function() {
                    // Received data
                    cb();
                });
            }, function(){
                callback();
            });
        });
    });
}

function getUrlData(url, name, flag, callback) {
    var req = http.get(url, function(res) {
        res.setEncoding('utf8');
        var rel_data = '';
        res.on('data', function(chunk) {
            rel_data += chunk;
        });

        res.on('end', function() {
            var json_rel_data = JSON.parse(rel_data);

            var curr_items = json_rel_data.data.items;
            if(!flag) {
                json_data.data.relationships[name].items = curr_items;
            } else {
                for(var i in curr_items) {
                    json_data.data.relationships[name].items.push(curr_items[i]);
                }
            }

            //console.log("REL DATA!!!! :: " + rel_data);
            var new_url = json_rel_data.data.paging.next_page_url;
            if(new_url) {
                var call_url = new_url+"&user_key=4f6fb15f3eb9187e1668d3d6604758d4";
                flag = true;
                getUrlData(call_url, name, flag, callback);
            }
            else {
                console.log(name + ": " + json_data.data.relationships[name].items.length);
                callback();
            }
        });
    });
}

module.exports = {
    getCompanyDetails: function (companyName, callback) {
        var url = "http://api.crunchbase.com/v/2/"+companyName+"?user_key=4f6fb15f3eb9187e1668d3d6604758d4";
        console.log(url);
        getData(url, function() {
            console.log("Done.");
            callback(json_data);
        });
    }
};