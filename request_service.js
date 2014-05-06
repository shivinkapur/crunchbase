var http = require('http');
var Db = require('mongodb').Db,
    MongoClient = require('mongodb').MongoClient,
    Server = require('mongodb').Server,
    assert = require('assert');


var options = {
	host: 'api.crunchbase.com',
	port: 80,
	path: '/v/1/service-providers.js?api_key=nay4a5482kcqxs956pfxr2me',
	method: 'GET'
};

var req = http.request(options, function(res) {
	res.setEncoding('utf8');
	var companies = '';
	res.on('data', function(chunk) {
		companies += chunk;
	});

	res.on('end', function() {
  		var jsonCompanies = JSON.parse(companies);
  		
		//Connect to database
  		var db = new Db('test', new Server('localhost', 27017));
  		db.open(function(err, db) {
  			if(err) throw err;
			
			var collection = db.collection('Service_Providers');
			for(var comp in jsonCompanies){
				collection.insert(jsonCompanies[comp]);
	  		}

	  		setTimeout(function() {
	  			console.log('Providers added to mongo');
      			db.close();
   			}, 100);
	  		
  		});
	});
}).end();
