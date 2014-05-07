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
            relation = json_data.data.relationships;
            for(var i in relation) {
                var url_i = relation[i].paging.first_page_url + "?user_key=f4c6f14f47ee61ff4bbb4686a4742dc4";
                console.log(i);
                var flag = false;
                getUrlData(url_i, i, flag, function() {
                    // Received data
                });
            }
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
                relation[name].items = curr_items;
            }else {
                for(var i in curr_items) {
                    relation[name].items.push(curr_items[i]);
                }
            }

            //console.log("REL DATA!!!! :: " + rel_data);
            var new_url = json_rel_data.data.paging.next_page_url;
            if(new_url) {
                var call_url = new_url+"&user_key=f4c6f14f47ee61ff4bbb4686a4742dc4";
                flag = true;
                getUrlData(call_url, name, flag, callback);
            }
            else {
                callback();
            }
        });
    });
}

var relation;
var url = "http://api.crunchbase.com/v/2/organization/facebook?user_key=f4c6f14f47ee61ff4bbb4686a4742dc4";
getData(url, function() {
    console.log("Done.");
    console.log(relation);
});