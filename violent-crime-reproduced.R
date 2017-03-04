#Install libraries below first
library (dplyr)
library (ggplot2)
library (knitr)
library (rvest)
library (RCurl)
library (XML)


#Get Html Crimedata table from 1990 - 2009
crimedata1990URL <- getURI("https://www2.fbi.gov/ucr/cius2009/data/table_01.html")
crimedata1990 <- readHTMLTable(crimedata1990URL, header = TRUE) %>% as.data.frame


#Get javascript table of crimedata from: https://ucr.fbi.gov/crime-in-the-u.s/2015/crime-in-the-u.s.-2015/tables/table-1/
#This data is from 1996 - 2015
#Use phantomjs to create html file
system("./phantomjs fbi.js")

#Build the crimedata Dataframe from the fbi.html 
crimedata1996 <- readHTMLTable("fbi.html")
crimedata1996 <- crimedata1996[1] %>% as.data.frame

#Use dpylr to select two columns and rename them in both dataframes
crimedata1990 <- select(crimedata1990, NULL..Year, NULL..Violent.crime.rate)
crimedata1990 <- rename (crimedata1990, Year = NULL..Year, Violent_Crime_Rate = NULL..Violent.crime.rate)
crimedata1990 <- slice(crimedata1990, 1:6)
crimedata1996 <- select(crimedata1996,NULL..Year, NULL..Violent.crime.rate.)
crimedata1996 <- rename(crimedata1996, Year = NULL..Year, Violent_Crime_Rate = NULL..Violent.crime.rate.)

#Shave data burs from Year
crimedata1996$Year <- gsub ('20146','2014',crimedata1996$Year)
crimedata1996$Year <- gsub ('20015', '2001', crimedata1996$Year)

#Merge both dataframes into one "crimedata" dataframe with years needed for reproducibility
crimedata <- rbind.data.frame(crimedata1990, crimedata1996)
crimedata$Violent_Crime_Rate <- as.numeric(as.character(crimedata$Violent_Crime_Rate))
crimedata$Year <- as.numeric(as.character(crimedata$Year))

#Reproduce essential visualization
ggplot(crimedata, aes(crimedata$Year, crimedata$Violent_Crime_Rate, group = 1)) +
  geom_point (size = 3) +
  geom_line() +
  scale_x_continuous(breaks=crimedata$Year) +
  xlab ("Year Reported") +
  ylab ("Violent Crime Rate per 100,000 Population") +
  labs (
    title = "Reported violent crime rate in the United States from 1990 to 2015",
    subtitle = "Data Sources:
                https://www2.fbi.gov/ucr/cius2009/data/table_01.html
                https://ucr.fbi.gov/crime-in-the-u.s/2015/crime-in-the-u.s.-2015/tables/table-1/ ",
    caption = "Source code:
               https://github.com/ianfrantz/Chart-Check-on-US-Violent-Crime
               Author: www.ianfrantz.com"
  )


#Labeled visualization
ggplot(crimedata, aes(crimedata$Year, crimedata$Violent_Crime_Rate, group = 1, label = crimedata$Violent_Crime_Rate))+
  geom_point (size = 2) +
  geom_line() +
  geom_label() +
  #geom_smooth(aes(group=1), method="loess") +
  xlab ("Year Reported") +
  ylab ("Violent Crime Rate per 100,000 Population") +
  labs (
    title = "Reported violent crime rate in the United States from 1990 to 2015",
    subtitle = "Data Sources:
                https://www2.fbi.gov/ucr/cius2009/data/table_01.html
                https://ucr.fbi.gov/crime-in-the-u.s/2015/crime-in-the-u.s.-2015/tables/table-1/ ",
    caption = "Source code:
               https://github.com/ianfrantz/Chart-Check-on-US-Violent-Crime
               Author: www.ianfrantz.com"
  )

#Visualization with LOESS regression
ggplot(crimedata, aes(crimedata$Year, crimedata$Violent_Crime_Rate, group = 1)) +
  geom_point (size = 2) +
  geom_line() +
  geom_smooth(aes(group=1), method="loess") +
  xlab ("Year Reported") +
  ylab ("Violent Crime Rate per 100,000 Population") +
  labs (
    title = "Reported violent crime rate in the United States from 1990 to 2015",
    subtitle = "Data Sources:
    https://www2.fbi.gov/ucr/cius2009/data/table_01.html
    https://ucr.fbi.gov/crime-in-the-u.s/2015/crime-in-the-u.s.-2015/tables/table-1/ ",
    caption = "Source code:
    https://github.com/ianfrantz/Chart-Check-on-US-Violent-Crime
    Author: www.ianfrantz.com"
  )

