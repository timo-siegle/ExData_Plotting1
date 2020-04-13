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
png(file = "plot4.png",
    width = 480,
    height = 480)

## Define plot aggregation.
par(mfcol = c(2, 2))

## Contruct first plot.
with(
    consumptionData,
    plot(
        Global_active_power ~ DateTime,
        type = "l",
        xlab = "",
        ylab = "Global Active Power",
        cex.axis = 0.75
    )
)

## Contruct second plot.
with(
    consumptionData,
    plot(
        Sub_metering_1 ~ DateTime,
        type = "l",
        xlab = "",
        ylab = "Energy sub metering",
        cex.axis = 0.75
    )
)
with(
    consumptionData,
    points(
        Sub_metering_2 ~ DateTime,
        type = "l",
        col = "red"
    )
)
with(
    consumptionData,
    points(
        Sub_metering_3 ~ DateTime,
        type = "l",
        col = "blue"
    )
)

legend(
    "topright",
    col = c("black", "red", "blue"),
    legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
    lty = 1, bty = "n"
)

## Contruct third plot.
with(
    consumptionData,
    plot(
        Voltage ~ DateTime,
        type = "l",
        xlab = "datetime",
        ylab = "Voltage",
        cex.axis = 0.75
    )
)

## Contruct fourth plot.
with(
    consumptionData,
    plot(
        Global_reactive_power ~ DateTime,
        type = "l",
        xlab = "datetime",
        cex.axis = 0.75
    )
)

dev.off()
