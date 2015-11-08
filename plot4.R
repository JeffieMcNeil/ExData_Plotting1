## Load the packages used in this script

library(dplyr); library(data.table)


## Check to see if the data file exists in the working directory, if not, download 
## and unzip the file

if(!file.exists("household_power_consumption.txt")){
    fileURL<-("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip")
    download.file(fileURL, destfile = "power.zip")
    unzip("power.zip", "household_power_consumption.txt")
}

## Read the data file, format the date column and subset the data into a data 
## frame with only the desired dates

data<- fread("household_power_consumption.txt", stringsAsFactors=TRUE, na.strings = "?")
data$Date <- as.Date(data$Date, "%d/%m/%Y") 
power<-subset(data, Date =="2007-02-01" | Date =="2007-02-02")
rm(data)
power<-mutate(power, DateTime= as.POSIXct(paste(power$Date, power$Time),
                                          format="%Y-%m-%d %H:%M:%S"))

## Open file device, create the plot, add the attributes and close the file device

png(file = "plot4.png", width = 480, height = 480, units = "px")
par("mfcol"=c(2,2), bg = "transparent")

##Top left plot
plot(power$DateTime,power$Global_active_power, type="l", 
     ylab="Global Active Power", xlab="")

## Bottom left plot
with(power,plot(DateTime, Sub_metering_1, type="l", col="black",
                ylab="Energy sub metering", xlab="", lwd=1))
with(power, lines(DateTime, Sub_metering_2, type="l", col="red", lwd=1))
with(power, lines(DateTime, Sub_metering_3, type="l", col="blue", lwd=1))
legend("topright",legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       lty=c(1,1,1), col=c("black", "red", "blue"), bty="n")

## Top right plot
with(power, plot(DateTime, Voltage, type="l", col="black", 
                 ylab="Voltage", xlab="datetime"))

## Bottom right plot
with(power, plot(DateTime, Global_reactive_power, type="l", col="black", 
                 ylab="Global_reactive_power", xlab="datetime"))
dev.off()
