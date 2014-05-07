var http = require('http');
var Db = require('mongodb').Db,
    MongoClient = require('mongodb').MongoClient,
    Server = require('mongodb').Server,
    assert = require('assert');

function getData(url, callback) {
	var req = http.get(url, function(res) {
		res.setEncoding('utf8');
		var companies = '';
		res.on('data', function(chunk) {
			companies += chunk;
		});

		res.on('end', function() {
	  		var jsonCompanies = JSON.parse(companies);
	  		//console.log(jsonCompanies.data.items);

			//Connect to database
	  		var db = new Db('test', new Server('localhost', 27017));
	  		db.open(function(err, db) {
	  			if(err) throw err;
				
				var collection = db.collection('Companies');
				var companies = jsonCompanies.data.items;
				for(var comp in companies){
		  			console.log(companies[comp])
					collection.insert(companies[comp]);
		  		}

		  		setTimeout(function() {
		  			console.log('Companies added to mongo');
	      			db.close();
	   			}, 100);
	  		});

	  		var new_url = jsonCompanies.data.paging.next_page_url;
	  		if(new_url) {
	  			var call_url = new_url+"&user_key=4f6fb15f3eb9187e1668d3d6604758d4";
	  			console.log(call_url);
	  			getData(call_url, callback);
	  		}
	  		else {
	  			callback();
	  		}
		});

		res.on('error', function() {
			console.log("Got error : " + e.message);
		});
	}).end();
}

var path = 'http://api.crunchbase.com/v/2/organizations?user_key=4f6fb15f3eb9187e1668d3d6604758d4'
getData(path, function() {
	console.log("Done");
});