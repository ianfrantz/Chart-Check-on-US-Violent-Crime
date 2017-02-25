#Install libraries below first

library (ggplot2)
library (knitr)
library (XML)
library (dplyr)

#Use phantomjs to create html file so rvest can read table data
system("./phantomjs fbi.js")

#Build the crimedata Dataframe from the fbi.html 
crimedata <- readHTMLTable("fbi.html")
crimedata <- crimedata[1] %>% as.data.frame

#Use dpylr to select only two columns and rename them
crimedata <- select(crimedata,NULL..Year, NULL..Violentcrime2)
crimedata <- rename(crimedata, Year = NULL..Year, Violent_Crimes = NULL..Violentcrime2)

ggplot(crimedata, aes(crimedata$Violent_Crime, crimedata$Year))+
  geom_point () +
  geom_line()
