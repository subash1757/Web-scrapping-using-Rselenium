library(RSelenium)
library(tidyr)
library(dplyr)
library(RMariaDB)
library(DBI)
# start a remote driver and navigate to the URL
driver <- rsDriver(browser = "firefox", port = 4444L)
remote_driver <- driver[["client"]]
url <- "https://www.google.com/travel/flights/search?tfs=CBwQAhooagwIAhIIL20vMGM4dGsSCjIwMjMtMDUtMjNyDAgDEggvbS8wZGx2MBooagwIAxIIL20vMGRsdjASCjIwMjMtMDUtMjdyDAgCEggvbS8wYzh0a3ABggELCP___________wFAAUgBmAEB"
remote_driver$navigate(url)

# get the text from the web page
text_name <- sapply(remote_driver$findElements(using = "class", "pIav2d"), function(x) x$getElementText())

# split the text on newlines and create a data frame
data_list <- strsplit(as.character(text_name), "\n")
df <- data.frame(do.call(rbind,data_list))

names(df) <- c("Time", "Airline", "Duration", "Route", "Stops", "CO2", "Emissions", "Price", "Type","Time2")
df

df<- t(df)
write.csv(df, file = "C:/Users/User/Documents/flight_project.csv", fileEncoding = "UTF-8")
#connecting database to R 
con <-DBI::dbConnect(MariaDB(),db="flight_data",host="localhost")

dbListTables(con)

dbWriteTable(con, "flight_table", df, row.names = FALSE)
