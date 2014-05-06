var http = require('http');
var Db = require('mongodb').Db,
    MongoClient = require('mongodb').MongoClient,
    Server = require('mongodb').Server,
    assert = require('assert');

function getData(url, callback) {
	var req = http.get(url, function(res) {
		res.setEncoding('utf8');
		var product = '';
		res.on('data', function(chunk) {
			product += chunk;
		});

		res.on('end', function() {
	  		var jsonProduct = JSON.parse(product);
	  		//console.log(jsonProduct.data.items);

			//Connect to database
	  		var db = new Db('test', new Server('localhost', 27017));
	  		db.open(function(err, db) {
	  			if(err) throw err;
				
				var collection = db.collection('Product');
				var product = jsonProduct.data.items;
				for(var p in product){
		  			console.log(product[p])
					collection.insert(product[p]);
		  		}

		  		setTimeout(function() {
		  			console.log('Product added to mongo');
	      			db.close();
	   			}, 100);
		  		
	  		});

	  		var new_url = jsonProduct.data.paging.next_page_url;
	  		if(new_url) {
	  			var call_url = new_url+"&user_key=f4c6f14f47ee61ff4bbb4686a4742dc4";
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

var path = 'http://api.crunchbase.com/v/2/products?user_key=f4c6f14f47ee61ff4bbb4686a4742dc4'
getData(path, function() {
	console.log("Done");
})