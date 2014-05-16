var http = require('http');
var Db = require('mongodb').Db,
    MongoClient = require('mongodb').MongoClient,
    Server = require('mongodb').Server,
    assert = require('assert');
var companyLib = require('./request_comp_details.js');
var async = require('async')

var db = new Db('test', new Server('localhost', 27017));
db.open(function(err, db) {
	if(err) throw err;

	var collection = db.collection('Companies');

	collection.find().toArray(function(err, result) {
		var arr = [];
		for(var i in result) {
			arr.push(result[i]);
			console.log(result[i]._id);
		}

		async.each(arr, 
			function(comp, cb) {
				var companyName = comp.path;
				if(!comp.visited) {
					companyLib.getCompanyDetails(companyName, function(companyDetails) {
						collection.update( {_id: comp._id }, {$set : {details : companyDetails, visited : true} } , {upsert: true}, function(err, rec) {
							if(err) throw err
							console.log(comp._id);
							cb();
						});
					});
				} else {
					console.log(comp.name + " visited");
					cb();
				}
			}, function(){
				db.close();
		});
	});
});