install.packages("spatstat")
install.packages("terra")

library(tidyverse)
library(spatstat)
library(terra)

bei
view(bei)

# plotting the data
plot(bei)

# changing dimension - cex
plot(bei, cex=.2)

# changing the symbol - pch
plot(bei, cex=.2, pch=19)

# additional datasets
bei.extra
plot(bei.extra)

# let's use only part of the dataset: elev
plot(bei.extra$elev)
elevation <- bei.extra$elev
plot(elevation)

# second method to select elements
elevation2 <- bei.extra[[1]]
plot(elevation2)

# passing from points to a continuous/creating a density map
densitymap <- density(bei)
densitymap
plot(densitymap) # density of the trees in the area
points(bei, cex = 0.2)

#changing the colour scheme
colorRampPalette(c("black", "red", "orange", "yellow"))
cl <- colorRampPalette(c("black", "red", "orange", "yellow"))(100)   # Yellow is the most impactful colour, your eyes are drawn to it first, therefore use it appropriately with the part of the plot that youare aiming to draw attention to
plot(densitymap, col = cl)

# redoing with only a couple colours
colorRampPalette(c("black", "red", "orange", "yellow"))
cl <- colorRampPalette(c("black", "red", "orange", "yellow"))(4)   # Yellow is the most impactful colour, your eyes are drawn to it first, therefore use it appropriately with the part of the plot that youare aiming to draw attention to
plot(densitymap, col = cl)

# multiframe [NOT FINISHED PROPERLY]
par(mfrow = c(3,1))
plot(densitymap)
plot(elev, grad, bei)

