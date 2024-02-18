# Topic: Population Ecology

# Install spatstat package for point pattern analysis
install.packages("spatstat")
library(spatstat)

# Will use the bei data for the analysis:
# data description:
# https://CRAN.R-project.org/package=spatstat

bei

# initial look at the data through plots
plot(bei)

# changing dimension - cex
plot(bei, cex=.2)

# changing the symbol - pch
plot(bei, cex=.2, pch=19)

# using additional datasets
bei.extra
plot(bei.extra)

# now we take only a subset of the dataset (elev) to do get more specific results
plot(bei.extra$elev)
elevation <- bei.extra$elev
plot(elevation)

# another method to achieve the same subsetting result is to indicate the element with square brackets
elevation2 <- bei.extra[[1]]
plot(elevation2)

# moving from points to a countinuous surface
densitymap <- density(bei)
plot(densitymap)
points(bei, cex=.2)

cl <- colorRampPalette(c("black", "red", "orange", "yellow"))(100)
plot(densitymap, col=cl)

cl <- colorRampPalette(c("black", "red", "orange", "yellow"))(4)
plot(densitymap, col=cl)

clnew <- colorRampPalette(c("dark blue", "blue", "light blue"))(100)
plot(densitymap, col=clnew)

plot(bei.extra)

elev <- bei.extra[[1]] # bei.extra$elev
plot(elev)

# create a multiframe view with different number of rows and columns
par(mfrow=c(1,2))
plot(densitymap)
plot(elev)

par(mfrow=c(2,1))
plot(densitymap)
plot(elev)

par(mfrow=c(1,3))
plot(bei)
plot(densitymap)
plot(elev)
