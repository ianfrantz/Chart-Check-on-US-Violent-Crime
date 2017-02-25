// scrape_fbi.js

var webPage = require('webpage');
var page = webPage.create();

var fs = require('fs');
var path = 'fbi.html'

page.open('https://ucr.fbi.gov/crime-in-the-u.s/2015/crime-in-the-u.s.-2015/tables/table-1/', function (status) {
  var content = page.content;
  fs.write(path,content,'w')
  phantom.exit();
});