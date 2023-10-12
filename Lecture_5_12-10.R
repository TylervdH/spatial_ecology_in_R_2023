# Why populations disperse over the landscape in a certain manner

library(sdm)
library(terra)

file <- system.file("external/species.shp", package = "sdm")
file

rana <- vect(file)
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

# Exercise: plot presences and absences together
par(mfrow = c(1,1))
plot(pres, col = "dark blue")
points(abse, col = "light blue")

#predictors: look at path (environmental variables)

elev <- system.file("external/elevation.asc", package = "sdm") # .asc is an extension "asci?" that is a typical image file
elevmap <- rast(elev) # from terra package
plot(elevmap)
points(pres, cex = .5)

temp <- system.file("external/temperature.asc", package = "sdm") # .asc is an extension "asci?" that is a typical image file
tempmap <- rast(temp)
plot(tempmap)
points(pres, cex = .5)

vegcov <- system.file("external/vegetation.asc", package = "sdm") # .asc is an extension "asci?" that is a typical image file
vegcovmap <- rast(vegcov)
plot(vegcovmap)
points(pres, cex = .5)

precip <- system.file("external/precipitation.asc", package = "sdm") # .asc is an extension "asci?" that is a typical image file
precipmap <- rast(precip)
plot(precipmap)
points(pres, cex = .5)

# grouping them together
par(mfrow = c(2,2))
plot(tempmap)
points(pres, cex = .5)
plot(vegcovmap)
points(pres, cex = .5)
plot(precipmap)
points(pres, cex = .5)
plot(elevmap)
points(pres, cex = .5)




