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

## Contruct plot.
par(mfrow = c(1, 1))
par(cex = 1)
with(
    consumptionData,
    plot(
        Global_active_power ~ DateTime,
        type = "l",
        xlab = "",
        ylab = "Global Active Power (kilowatts)"
    )
)

## Save plot to a PNG file.
dev.copy(png,
         file = "plot2.png",
         width = 480,
         height = 480)
dev.off()
