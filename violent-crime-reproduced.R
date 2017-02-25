#Install libraries below first

library (rvest)
library (ggplot2)
library (knitr)
library (XML)

#Use phantomjs to create html file so rvest can read table data
system("./phantomjs fbi.js")

crimedataurl <- ("https://ucr.fbi.gov/crime-in-the-u.s/2015/crime-in-the-u.s.-2015/tables/table-1")

crimedata <- readHTMLTable("fbi.html")
crimedata <- crimedata[1] %>% as.data.frame

