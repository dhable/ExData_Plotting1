# plot1.R
#
# Download the file from the internet if it doesn't exist in the current
# working directory. 
if(file.exists("./household_power_consumption.txt")) {
  data_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(data_url, "./tmp_data_file.zip", method="curl")
  unzip("./tmp_data_file.zip")
  file.remove("./tmp_data_file.zip")
}

# Read the data file into memory with the Date and Time columns defined as
# character types. Then build a DateTime column that is an actual POSIXlt
# type that is equlvelent to timestamp specified in the Date and Time column.
data <- read.table("./household_power_consumption.txt", sep=";", na.strings="?", header=TRUE,
                   colClasses=c("character", "character", "numeric"))
data <- transform(data, DateTime=strptime(paste(Date, Time), "%d/%m/%Y %H:%M:%S"))


# Now filter down the data to the two days in Feburary () that
# we're interested in.
filter_start <- strptime("01/02/2007 00:00:00", "%d/%m/%Y %H:%M:%S")
filter_end <- strptime("03/02/2007 00:00:00", "%d/%m/%Y %H:%M:%S")
filtered_data <- subset(data, DateTime > filter_start & DateTime < filter_end)


# Generate the plot - a historgram of the global active power frequency for 
# the date range. We generate this plot into a PNG file in the current working
# directory.
if(file.exists("./plot1.png")) {
  file.remove("./plot1.png")
}
png(filename = "./plot1.png")
hist(filtered_data$Global_active_power, col="red", main="Global Active Power",
     xlab="Global Active Power (kilowatts)",
     ylab="Frequency", ylim=c(0, 1200))
dev.off()