require("sqldf")

## Download data.
filename <- "dataset"
if (!file.exists(filename)) {
    fileURL <-
        "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(fileURL, filename, method = "curl")
}

## Unzip data.
if (!file.exists("household_power_consumption.txt")) {
    unzip(filename)
}

## Import consumption data from 1 and 2 February.
consumptionData <-
    read.csv.sql(
        "household_power_consumption.txt",
        "select * from file where Date in ('1/2/2007', '2/2/2007');",
        header = TRUE,
        sep = ";"
    )

## Create new column containing date time.
for (row in 1:nrow(consumptionData)) {
    consumptionData[row, "DateTime"] <-
        as.POSIXct(paste(consumptionData[row, "Date"], (consumptionData[row, "Time"])), format = "%d/%m/%Y %H:%M:%S")
}

## Save plot to a PNG file.
## Have to use the png command because of problem with lagend box width.
png(file = "plot3.png",
    width = 480,
    height = 480)

## Contruct plot.
par(mfrow = c(1, 1))

with(
    consumptionData,
    plot(
        Sub_metering_1 ~ DateTime,
        type = "l",
        xlab = "",
        ylab = "Energy sub metering"
    )
)
with(
    consumptionData,
    points(
        Sub_metering_2 ~ DateTime,
        type = "l",
        xlab = "",
        ylab = "Energy sub metering",
        col = "red"
    )
)
with(
    consumptionData,
    points(
        Sub_metering_3 ~ DateTime,
        type = "l",
        xlab = "",
        ylab = "Energy sub metering",
        col = "blue"
    )
)

## Set text size and create legend
legend(
    "topright",
    col = c("black", "red", "blue"),
    legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
    lty = 1, lwd = 1
)

dev.off()
