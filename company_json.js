var http = require('http');

function getData(url, callback) {
	var req = http.get(url, function(res) {
		res.setEncoding('utf8');

		var company = '';
		res.on('data', function(chunk) {
			company += chunk;
		});

		res.on('end', function() {
  			var jsonCompany = JSON.parse(company);
  			relationships = jsonCompany.data.relationships;

  			for(var item in relationships) {
				var url = relationships[item].paging.first_page_url + "?user_key=f4c6f14f47ee61ff4bbb4686a4742dc4";

  				getUrlData(url, function(itemData) {
  					console.log(itemData);

  				});
  			}
	  	});	
	});
}

function getUrlData(url, callback) {
	var req = http.get(url, function(res) {
		res.setEncoding('utf8');

		var item = '';
		res.on('data', function(chunk) {
			item += chunk;
		});

		res.on('end', function() {
			var parsed_item = JSON.parse(item);

			var db = new Db('test', new Server('localhost', 27017));
	  		db.open(function(err, db) {
	  			if(err) throw err;
				
				var collection = db.collection('Companies');
				for(var comp in companies) {
		  			console.log(companies[comp]);
					collection.insert(companies[comp]);
		  		}

		  		setTimeout(function() {
		  			console.log('Companies added to mongo');
	      			db.close();
	   			}, 100);
	  		});

			var new_url = parsed_item.data.paging.next_page_url;
	  		if(new_url) {
	  			var call_url = new_url+"&user_key=f4c6f14f47ee61ff4bbb4686a4742dc4";
	  			console.log(call_url);
	  			getUrlData(call_url, callback);
	  		}
	  		else {
	  			callback(parsed_item);
	  		}
		});
	});
}

var path = 'http://api.crunchbase.com/v/2/organization/facebook?user_key=f4c6f14f47ee61ff4bbb4686a4742dc4';
getData(path, function() {
	console.log("Done");
});