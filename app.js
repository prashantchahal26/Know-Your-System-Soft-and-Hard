var express = require("express"),
    app     = express(),
    body    = require("body-parser"),
    ping = require('ping'),
    cors = require('cors');
 

app.use(body.urlencoded({extended : true}));
app.use(body.json());
app.use(cors());

var one='192',two='168',three='1';


app.get("/pwsh/:ip", function(req, res)
{
	var ip = req.params.ip;

	command(ip, function(ans)
	{
		res.json(ans);
	});
});

function command(ip, callback)
{
	var spawn = require("child_process").spawnSync,child;
	var str = "";
	child = spawn("powershell.exe",["C:\\Users\\inspiron\\Desktop\\Work\\Summer\\backend\\OSWin.ps1 -remoteComputer "+ip]);
	str = child.stdout.toString();
	str = JSON.parse(str);
	if(child.stderr.toString() !== "")
	 	return commandLinux(ip, callback);
	callback(str);
}

function commandLinux(ip, callback)
{
	var spawn = require("child_process").spawnSync,child;
	var str = "";
	child = spawn("powershell.exe",["C:\\Users\\inspiron\\Desktop\\Work\\Summer\\backend\\DetailsLinux.ps1 -remoteComputer "+ip]);
	str = child.stdout.toString();
	str = JSON.parse(str);
	if(child.stderr.toString() !== "")
	 	return callback("ERROR");
	return callback(str);
}


app.post("/pwsh", function(req, res)
{
	var ip = one+"."+two+"."+three+"."
	var i = parseInt(req.body.IP1);
	var j = parseInt(req.body.IP2);
	var hosts = [];
	while(i <= j)
	{
		hosts.push(ip+i);
		i++;
	}
	
	var aProm = [];
	
	hosts.forEach(function(host)
	{
		aProm.push(new Promise((resolve) => {checkStatus(host,resolve);}));
	});

	Promise.all(aProm).then((data)=>{
		res.json(data);
	});
});

function checkStatus(host, resolve)
{
	var spawn = require('child_process').spawn;
 
	var child = spawn("powershell.exe",["C:\\Users\\inspiron\\Desktop\\Work\\Summer\\backend\\check.ps1 -remoteComputer "+host]);
	child.stdout.on("data",function(data)
	{
		var str = {'host': host,
		'alive': data.toString()};
		resolve(str);
	});
}


app.post("/ping",function(req,res)
{
	var ip = one+"."+two+"."+three+"."
	var i = parseInt(req.body.IP1);
	var j = parseInt(req.body.IP2);
	var hosts = [];
	var arr = [];
	while(i <= j)
	{
		hosts.push(ip+i);
		i++;
	}

	let aPromises = [];

	hosts.forEach(function (host) {
    	aPromises.push(ping.promise.probe(host));
	});

	Promise.all(aPromises).then(function(results){
		arr = results;
		res.json(arr);
	});
});


app.post("/admin",function(req, res)
{
	one = req.body.one;
	two = req.body.two;
	three = req.body.three; 
    res.json("success");    
});


app.listen(3000,function()
{
    console.log("Server Started.");
});