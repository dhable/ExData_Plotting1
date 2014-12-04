# plot2.R

data_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
data_zip_filename <- "exdata-data-household_power_consumption.zip"
data_table_filename <- "household_power_consumption.txt"
plot_output_filename <- "plot2.png"


# Download the file from the internet if it doesn't exist in the current
# working directory. 
if(!file.exists(data_table_filename)) {
  download.file(data_url, data_zip_filename, method="curl")
  unzip(data_zip_filename)
  file.remove(data_zip_filename)
}

# Read the data file into memory with the Date and Time columns defined as
# character types. Then build a DateTime column that is an actual POSIXlt
# type that is equlvelent to timestamp specified in the Date and Time column.
data <- read.table(data_table_filename, sep=";", na.strings="?", header=TRUE,
                   colClasses=c("character", "character", "numeric"))
data <- transform(data, DateTime=strptime(paste(Date, Time), "%d/%m/%Y %H:%M:%S"))


# Now filter down the data to the two days in Feburary () that
# we're interested in.
filter_start <- strptime("01/02/2007 00:00:00", "%d/%m/%Y %H:%M:%S")
filter_end <- strptime("03/02/2007 00:00:00", "%d/%m/%Y %H:%M:%S")
filtered_data <- subset(data, DateTime > filter_start & DateTime < filter_end)


# Generate the plot
if(file.exists(plot_output_filename)) {
  file.remove(plot_output_filename)
}
png(filename = plot_output_filename)
with(filtered_data, plot(DateTime, Global_active_power, type="l",
                         xlab="", ylab="Global Active Power (kilowatts)"))
dev.off()