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

function getOrgData(path, callback) {
	var url = "http://api.crunchbase.com/v/2/"+path+"?user_key=4f6fb15f3eb9187e1668d3d6604758d4";

	getData(url, function(company) {
		console.log("get org data function : " + company);
		callback(company);
	});
}

function getData(url, callback) {
	http.get(url, function(res) {
		res.setEncoding('utf8');
		var comp = '';
		res.on('data', function(chunk) {
			comp += chunk;
		});

		res.on('end', function() {
			//console.log(company);
			callback(comp);
		});

	});
}

var db = new Db('test', new Server('localhost', 27017));
db.open(function(err, db) {

	db.collection('Companies', function(err, companies) {
		companies.find().toArray(function(err, docs) {
			if(err) {
				console.log(err);
			}

			console.log(docs[1].path);

			var org_path = docs[1].path;

			getOrgData(org_path, function(company) {

				var comp = JSON.parse(company);
				console.log("print in main function : " + company);

				console.log(docs[1]._id);

				companies.update({ "_id" : docs[1]._id}, comp, {upsert: true}, function(err, res) {
					if(err) console.log(err);

					db.close();
				});
			});

		});
	});
});

