install.packages("sdm")

library(sdm)
library(terra)

file <- system.file("external/species.shp", package = "sdm")
file

rana <- vect(file) # import the data
rana # presence/absence dataset just says 1 or 0 (not an abundance dataset which gives quantities)
summary(rana)
view(rana$Occurrence)
par(mfrow=c(1,1))
plot(rana, cex = .5) # this gives presences and absences all together

# Selecting only presences
pres <- rana[rana$Occurrence == 1,]  # the quadratic parentheses are used to select an element in the data
abse <- rana[rana$Occurrence == 0,] # these commas at the end close the sentence

# Exercise: plot presences and absences one beside the other
par(mfrow = c(1,2))
plot(pres)
plot(abse)

# in case of graphical nulling use
dev.off()

# Exercise: plot presences and absences together
par(mfrow = c(1,1))
plot(pres, col = "dark blue")
points(abse, col = "light blue")

# predictors: environmental variables
# file <- system.file("external/species.shp", package="sdm")
# rana <- vect(file)

# elevation predictor
elev <- system.file("external/elevation.asc", package = "sdm") # .asc is an extension "asci?" that is a typical image file
elevmap <- rast(elev) # from terra package
plot(elevmap)
points(pres, cex = .5)

# temperature predictor
temp <- system.file("external/temperature.asc", package = "sdm") # .asc is an extension "asci?" that is a typical image file
tempmap <- rast(temp)
plot(tempmap)
points(pres, cex = .5)

# vegetation cover predictor
vegcov <- system.file("external/vegetation.asc", package = "sdm") # .asc is an extension "asci?" that is a typical image file
vegcovmap <- rast(vegcov)
plot(vegcovmap)
points(pres, cex = .5)

# precipitation predictor
precip <- system.file("external/precipitation.asc", package = "sdm") # .asc is an extension "asci?" that is a typical image file
precipmap <- rast(precip)
plot(precipmap)
points(pres, cex = .5)

# grouping them together in a final multiframe to make comparisons
par(mfrow = c(2,2))
plot(tempmap)
points(pres, cex = .5)
plot(vegcovmap)
points(pres, cex = .5)
plot(precipmap)
points(pres, cex = .5)
plot(elevmap)
points(pres, cex = .5)
