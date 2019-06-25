# MJL 2019-06-24
# Ubuntu 18.04.1 Lts
# Rstudio Version 1.1.456
# R version 3.6.0

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

# Select Date and Global_active_power ; subset dates: include only 2007-02-01 and 2007-02-02
powerConsumptionSub.dat <- powerConsumption.dat %>%
  dplyr::select(Date, Time, Global_active_power) %>%
  dplyr::filter(Date == "2007-02-01" | Date == "2007-02-02")

# Convert Global_active_power to numeric
powerConsumptionSub.dat$Global_active_power <- as.numeric(powerConsumptionSub.dat$Global_active_power)

# Merge date and time for series
powerConsumptionSub.dat$Date2 <- as.POSIXct(paste(powerConsumptionSub.dat$Date, powerConsumptionSub.dat$Time), format="%Y-%m-%d %H:%M:%S")

#--------------------------------------------------Plot 2-------------------------------------------------------#
# Time series of Global_active_power, save to file
png("plot2.png", width=480, height=480) # Open connection ; specify path/file name and image dimensions
plot(powerConsumptionSub.dat$Date2, powerConsumptionSub.dat$Global_active_power, type = "l", xlab = "", ylab = "Global Active Power (kilowatts)")
dev.off()
