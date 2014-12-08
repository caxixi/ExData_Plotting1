#loading needed libraries 
library(dplyr)
library(lubridate)

#read table:
HPC<-read.table("household_power_consumption.txt", header=TRUE, sep=c(";"), strip.white=TRUE, na.strings =c("?", ""))

# create a new data frame  containing only data from the two requested days:
HPC2d<-rbind (filter(HPC, (Date=="1/2/2007")), filter(HPC, (Date=="2/2/2007")))

#in order to create one time collumns: a. transforming the Date and Time columns to
#charachter collums b. creating a ew column that combine the two c. transforming the
#format of the new column to time format d. re - arranging the data frame to include
#that one new time column and not the Date and Tie columns, that are redundant now.

#a. transforming the Date and Time columns to charachter collums
HPC2d$Date<-as.character(HPC2d$Date)
HPC2d$Time<-as.character(HPC2d$Time)

#b. creating a new column that combine the two 
HPC2d$DateTime = paste(HPC2d$Date, HPC2d$Time)

#c. transforming the format of the new column to time format
HPC2d$DateTime<-as.POSIXct(strptime(HPC2d$DateTime,format="%d/%m/%Y %H:%M:%S"))

#d. re - arranging the data frame to include
#that one new time column and not the Date and Tie columns, that are redundant now.
HPC2days<-select(HPC2d, DateTime,Global_active_power:Sub_metering_3)

png(filename = "plot4.png",
    width = 480, height = 480, units = "px", pointsize = 12,
    bg = "white")


#Setting the lot arrangement' 2 rows, two columns:
par(mfrow = c(2, 2), mar = c(4, 4, 2, 1), oma = c(0, 0, 2, 0))

#plot 1:
plot(HPC2days$DateTime, HPC2days$Global_active_power, type="l", xlab=(""), 
     ylab="global Active Power (kilowatts)")

#plot 2:
plot(HPC2days$DateTime, HPC2days$Sub_metering_1, type="l", xlab=(""), 
     ylab="Energy sub metering")
lines(HPC2days$DateTime, HPC2days$Sub_metering_2, type="l", 
     col="red")
lines(HPC2days$DateTime, HPC2days$Sub_metering_3, type="l", 
      col="blue")

#plot 3:
plot(HPC2days$DateTime, HPC2days$Voltage, type="l", xlab=("datetime"), 
     ylab="Voltage")

#plot 4:
plot(HPC2days$DateTime, HPC2days$Global_reactive_power, type="l", xlab=("datetime"), 
     ylab="Global_reactive_power")

       
#turning off device driver:
dev.off()