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

## Contruct plot.
par(mfrow = c(1, 1))
par(cex = 1)
with(
    consumptionData,
    hist(
        Global_active_power,
        main = "Global Active Power",
        xlab = "Global Active Power (kilowatts)",
        col = "red"
    )
)

dev.copy(png,
         file = "plot1.png",
         width = 480,
         height = 480)
dev.off()
