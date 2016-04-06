#!/usr/bin/node
'use strict';

//Lets require/import the HTTP module
var http = require('http');

//Lets define a port we want to listen to
var port = process.env.SERVER_PORT || 8080;
var host = 'localhost';

var response_json = JSON.stringify({
	'healthy': true,
	'status': 'live'
}, null, 3);

//We need a function which handles requests and send response
function handleRequest(request, response){
	response.setHeader('Content-Type', 'application/json');
    response.end(response_json);
}

//Create a server
var server = http.createServer(handleRequest);

//Lets start our server
server.listen(port, function(){
    //Callback triggered when server is successfully listening. Hurray!
    console.log("Server listening on: http://%s:%s", host, port);
});