# MJL 2020-11-19
# Ubuntu 20.04.1 Lts
# Rstudio Version 1.3.1093
# R version 4.0.3

# Clear workspace
rm(list = ls()); gc()

# library statements
required.packages <- c("dplyr")
lapply(required.packages, require, character.only = TRUE)

# Program inputs:
urlDat <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"  # Path to dataset

# Set working directory
mainDir <- "/home/michael/Documents/coursera_assignments/exploratory_data_analysis/week1"  # Specify working directory (optional)
if (file.exists(mainDir)){
  setwd(mainDir)
}

#-------------------------------------------------Import raw data-------------------------------------------------#
# Create data subfolder if it does not already exist
if(!file.exists("./data")){  
  dir.create("./data")
}  

# Download zip file from url destination
if(!file.exists("./data/Dataset.zip")) {  
  download.file(urlDat, destfile="./data/Dataset.zip")  
}

# Unzip directory  
if(!file.exists("./data/household_power_consumption.txt")) {
  unzip(zipfile="./data/Dataset.zip",exdir="./data")  
}

#-------------------------------------------------Process Data------------------------------------------------#
# Read in data
powerConsumption.dat <- read.table("./data/household_power_consumption.txt", header=TRUE, sep=";", stringsAsFactors=FALSE, dec=".")

# Clean up date
powerConsumption.dat$Date <- as.Date(powerConsumption.dat$Date, "%d/%m/%Y")
powerConsumption.dat$Time <- format(powerConsumption.dat$Time, format="%H:%M:%S")

# Select Date, Global_active_power, Voltage, sub_metering 1-3, and Global_reactive_power ; subset dates: include only 2007-02-01 and 2007-02-02
powerConsumptionSub.dat <- powerConsumption.dat %>%
  dplyr::select(Date, Time, Global_active_power, Voltage, Sub_metering_1, Sub_metering_2, Sub_metering_3, Global_reactive_power) %>%
  dplyr::filter(Date == "2007-02-01" | Date == "2007-02-02")

# Convert Variables to numeric
powerConsumptionSub.dat$Global_active_power <- as.numeric(powerConsumptionSub.dat$Global_active_power)
powerConsumptionSub.dat$Voltage <- as.numeric(powerConsumptionSub.dat$Voltage)
powerConsumptionSub.dat$Sub_metering_1 <- as.numeric(powerConsumptionSub.dat$Sub_metering_1)
powerConsumptionSub.dat$Sub_metering_2 <- as.numeric(powerConsumptionSub.dat$Sub_metering_2)
powerConsumptionSub.dat$Sub_metering_3 <- as.numeric(powerConsumptionSub.dat$Sub_metering_3)
powerConsumptionSub.dat$Global_reactive_power <- as.numeric(powerConsumptionSub.dat$Global_reactive_power)

# Merge date and time for series
powerConsumptionSub.dat$Date2 <- as.POSIXct(paste(powerConsumptionSub.dat$Date, powerConsumptionSub.dat$Time), format="%Y-%m-%d %H:%M:%S")

#--------------------------------------------------Plot 4-------------------------------------------------------#
# 4 Time series line plots of Global Active Power, Voltage, Energy sub metering and Global reactive power; save to file
png("plot4.png", width=480, height=480) # Open connection ; specify path/file name and image dimensions

par(mfrow = c(2,2)) # Set graphic device to support 4 plots - 2x2

# Construct 4x4 Plot
with(powerConsumptionSub.dat, {
  plot(Date2, Global_active_power, type = "l", xlab = "", ylab = "Global Active Power") # Global Active Power - 1,1
  
  plot(Date2, Voltage, type = "l", xlab = "datetime", ylab = "Voltage") # Voltage - 1,2
  
  plot(Date2, Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering") # Sub metering - 2,1
  lines(Date2, Sub_metering_2, type = "l", col = "red")
  lines(Date2, Sub_metering_3, type = "l", col = "blue")
  legend(c("topright"), c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), bty = "n", lty= 1, lwd = 2, col = c("black", "red", "blue"))
  
  plot(Date2, Global_reactive_power, type = "l", xlab = "datetime", ylab = "Global_reactive_power") # Global reactive power - 2,2
})

dev.off() # Close Graphics Device connection