#plot2.R
#
# Peter Partch
#
# for Exploratory Data Analsys project 1
#
# The prior course, Getting and Cleaning Data, introduced the dplyr and lubridate packages
# as part of the optional swirl assignment. Since the project instructions left date/time conversion
# techniques a bit 'vague' (ie: "You may find it useful to ... using the strptime() and as.Date() functions"),
# I chose to use the libridate package instead of strptime and/or as.Date
#
# I also use the dplyr package to create a data frame table so I can leverage the mutate function to 
# add a new datetime column and modify the classes of the other columns (convert to POSIXct and/or numeric)
#
# I assume that the full text input file is in the current working directory.

#fileUrl <- file.path("data","household_power_consumption.txt")
fileUrl <- "household_power_consumption.txt"

rawdata <- read.csv2(fileUrl, na.strings = "?", stringsAsFactors = FALSE)

if (require("dplyr") == FALSE)
{
  install.packages("dplyr")
  library(dplyr)
}

if (require("lubridate") == FALSE)
{
  install.packages("lubridate")
  library(lubridate)
}

datatbl <- tbl_df(rawdata) #convert to dplyr data frame table

#use dplyr package method 'mutate' to operate on the data frame table to do the following
# create new column called 'datetime' to hold the POSIXct combined date-time
# convert the Date column to a POSIXct class (I do this to help test if there is any issues with the Date string...see note on filter below)
# leave the Time column as a string (I don't need it other than for the new column creation)
# convert all other columns to numeric
datatbl <- mutate(datatbl,  datetime = dmy_hms(paste(Date,Time)), Date = dmy(Date),
                  Global_active_power = as.numeric(Global_active_power),
                  Global_reactive_power = as.numeric(Global_reactive_power),
                  Voltage = as.numeric(Voltage),
                  Global_intensity = as.numeric(Global_intensity),
                  Sub_metering_1 = as.numeric(Sub_metering_1),
                  Sub_metering_2 = as.numeric(Sub_metering_2),
                  Sub_metering_3 = as.numeric(Sub_metering_3))

#use dplyr filter function to save only the required rows (see data selections below)
#NOTE: I converted the input data to POSIXct format and use the lubridate ymd functions below 
#      (instead of doing a simple string compare) since the conversions will fire off warnings or
#      errors if there is something wrong in the date string formats during conversions. This 
#      is a good test to verify that the input strings are not broken in some way.
datasubset <- filter(datatbl, Date == ymd("2007-02-01") | Date == ymd("2007-02-02"))

#Note: the following plot code is structured the same for all of my plots
#  use attach/detach to setup the root data source for the plots
#  cache the original par settings and restore them (even though most of the plots dont change them)...just me being careful

attach(datasubset)

opar <- par(no.readonly=TRUE) #save original par settings

#Plot 2 plot
png("plot2.png")

plot(datetime, Global_active_power, type="n", xlab="", ylab="Global Active Power (kilowatts)")
lines(datetime,as.numeric(Global_active_power))

par(opar)

dev.off() #close and save the file to disk

detach(datasubset)