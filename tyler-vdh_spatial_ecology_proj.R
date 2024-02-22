# STUDY AIM: Explore the harsh effect Australia's summer bushfires have on vegetation and moisture levels

## specifically at the New South Wales, Blue Mountains National Park Wildfires, in the Summer of November 2019 to February 2020 

# Install necessary packages if required and then load them using library function
# install.packages("tidyverse")  ## ensure this is in quotes to install package if required

library(tidyverse) # set of packages used for data science (specifically loaded here for the pipe function)
library(terra) # provides methods to manipulate geographic (spatial) data in "raster" and "vector" form.
library(patchwork) # required to be able to visualize multiple ggplots next to each other
library(RStoolbox) # allows to fortify raster data
library(gridExtra) # provides functions to arrange grid-based plots
library(viridis) # provides colorblind friendly color maps
library(raster) # functions which enable manipulation of data in 'raster' format

# set working directory to location for access to project files on computer
setwd("/Users/tylervdh/Desktop/R/spatial_ecology_in_R/test")

# list and check the data and files present in the directory
list.files() 

# Import images downloaded from Copernicus' Sentinel-2 L1C

# In this project we took files pre-cut in Copernicus and then cropped them to remove the interference of the urban area of Penrith
extent_mountains <- extent(16663731, 16757000, -4040000, -3925000)

## This cropped range then focuses specifically on the Blue Mountains National Park and it's surrounding natural area
## This also removed some cloud cover which is especially vital for the moisture content analysis as Band 11 has very limited cloud penetration

# Now we read in the desired files for a date at the start of summer and a day at the end of summer
november_bands <- intersect(list.files(pattern = "2019-11-01"), list.files(pattern = "tiff"))
# Check imported files
november_bands

# Now we use the pipe function to apply the ~rast(), ~stack() and ~crop() function to the January bands
nov_stack <- november_bands %>%  
  rast() %>%    # creates a RasterBrick - spatially referenced surface divided into three domensions
  stack() %>%     # stacks the bands on top of each other
  crop(extent_mountains)  # crops the geographical dimensions of the RasterBrick

# Can have a quick look at the output which gives us a RasterBrick, a multi-layer file
nov_stack
# Then plot the output to see the 6 different bands
plot(nov_stack)

# The same process is then repeated for the January bands
january_bands <- intersect(list.files(pattern = "2020-01-30"), list.files(pattern = "tiff"))
january_bands
jan_stack <- january_bands %>% 
  rast() %>% 
  stack() %>% 
  crop(extent_mountains)

jan_stack
plot(jan_stack)

# Exercise: plot in a multiframe the bands with different color ramps

# With the colorRampPalette() function, create a colour palette with a gradient of 150
cl_test <- colorRampPalette(c("blue","green","yellow"))(150) 

# Now lets plot the two stacks with the new colour palette
par(mfrow=c(2,3))
# The par() function creates multiple graphs within a raster
# mfrow specifies the size by indicating rows and columns
plot(nov_stack, col = cl_test) # plot November bands with colours
plot(jan_stack, col = cl_test) # plot January bands with colours

# However, more beneficial to plot with the palette more useful for colorblind people
cl_viridisc <- colorRampPalette(viridis(7))(255)
plot(nov_stack, col = cl_viridisc) # plot November bands with colours
plot(jan_stack, col = cl_viridisc) # plot January bands with colours

# To show different bands in different colors, a number of colour palettes can be created and plotted
# Here we can experiment with the two stacks   
par(mfrow = c(1,2))

    ## band 2 blue element 1, stacksent[[1]] 
    clb <- colorRampPalette(c("blue4","royalblue2","skyblue")) (100)
    plot(nov_stack[[1]], col = clb)
    plot(jan_stack[[1]], col = clb)
    
    ## band 3 green element 2, stacksent[[2]]
    clg <- colorRampPalette(c("dark green","palegreen4","darkseagreen1")) (100)
    plot(nov_stack[[2]], col = clg)
    plot(jan_stack[[2]], col = clg)
    
    ## band 4 red element 3, stacksent[[3]]
    clr <- colorRampPalette(c("brown4","red3","indianred1")) (100)
    plot(nov_stack[[3]], col = clr)
    plot(jan_stack[[3]], col = clr)
    
    ##  band 8 NearInfraRed element 4, stacksent[[4]]
    clnir <- colorRampPalette(c("firebrick4","darkorange2","lightgoldenrod")) (100)
    plot(nov_stack[[4]], col = clnir)
    plot(jan_stack[[4]], col = clnir)

#The function ~plotRGB() can be used to stack the different band layers on top of each other
    # For natural colours plot assign the parameters to the bands below
par(mfrow = c(2,2))
plotRGB(nov_stack, r=3, g=2, b=1)  
plotRGB(jan_stack, r=3, g=2, b=1)    
  
    # b4 contains the NearInfraRed data, so with the following changes the data is visualized as green and more clearly shows the distribution of forest area  
plotRGB(nov_stack, r=3, g=4, b=2)
plotRGB(jan_stack, r=3, g=4, b=2)

dev.off() # use this function to close the multiframe


# A multitemporal analysis will then combine the two by calculating the difference between the images pixel by pixel

dif_19to20 <- nov_stack[[4]]-jan_stack[[4]]
plot(dif_19to20, col = cl_viridisc)

# We can take this one step further and calculate the normalised difference vegetation index (NDVI) - distinguishes between soil and vegetation
# To do this we compare the values of NearInfraRed and Red light reflection and plot them to estimate the vegetation coverage

dvi_nov <- nov_stack[[4]] - nov_stack[[3]]
ndvi_nov <- nov_stack[[4]] - nov_stack[[3]]/nov_stack[[4]] + nov_stack[[3]]

dvi_jan <- jan_stack[[4]] - jan_stack[[3]]
ndvi_jan <- jan_stack[[4]] - jan_stack[[3]]/jan_stack[[4]] + jan_stack[[3]]

plot(dvi_nov)
plot(dvi_jan)
plot(ndvi_nov)
plot(ndvi_jan)
dev.off()

# then we look at the difference between the two times
difndvi_19to20 <- ndvi_nov - ndvi_jan
plot(difndvi_19to20, col = inferno(256))
# We then plot this to get a map with vegetation loss yellow, vegetation gain (purple), relatively unchanged areas (red)
# this colour palette is used for its suitability to colour blindness

# next we can calculate the vegetation indices using this DVI

# Using R the areas can be classified into different categories using an automatically generated values of the NIR and red values
par(mfrow = c(2,1))
class_nov <- unsuperClass(nov_stack[[c(4,3,2)]], nClasses = 2, ) # nClasses = 2 signals that there will be 2 classes
class_nov             # showing some of the characteristics of the class_nov generated by the ~unsuperClass() function

plot(class_nov$map)   # plotting the data with class 1 being Healthy Vegetation and class 2 being Burnt/Anthropogenic impacted areas
freq(class_nov$map)   # showing the frequency of pixels attributed to each class

f_nov <- 515512/(515512 + 191348) # Healthy Vegetation
h_nov <- 191348/(191348 + 515512) # Burnt/Anthropogenic Vegetation

f_nov # this output then gives us the final value for the Surface Cover of Healthy Vegetation
h_nov

# class 1: healthy vegetation - 515512 - ~73 %
# class 2: burnt/anthropogenic  - 191348 - ~27 %

class_jan <- unsuperClass(jan_stack[[c(2,3,4)]], nClasses = 2, ) # nClasses=2 signals that there will be 2 classes
class_jan             # showing some of the characteristics of d1c

plot(class_jan$map)   # plotting the data with class 1 being Healthy Vegetation and class 2 being Burnt/Anthropogenic impacted areas
freq(class_jan$map)   # showing the frequency of pixels attributed to each class

f_jan <- 480623/(480623 + 226237) # Healthy Vegetation
h_jan <- 226237/(226237 + 480623) # Burnt/Anthropogenic impact

f_jan
h_jan

# class 1: healthy vegetation - 480623 - ~68 %
# class 2: burnt/anthropogenic  - 226237 - ~32 %

# We then create a vector to label our two categories
landcover <- c("Healthy","Burnt/Anthro")

# And we asign the percentages to a vector for each time stamp in order to create a data.frame
percent_nov <- c(72.93,27.07)
percent_jan <- c(67.99,32.01)

# use the ~data.frame() function to create a data frame
percent <- data.frame(landcover,percent_nov,percent_jan)
percent         #showing the finished tabulated data frame

dev.off()

# we can then use the ~write.table() function to save the dataframe
write.table(percent, file = "/Users/tylervdh/Desktop/R/spatial_ecology_in_R/dataframe_1.txt")

# using this data frame we are able to create simple ggplots to visualise our results
# next we create a column chart to convey the difference in vegetation cover between the two surface categories
percent_plot_nov <- ggplot(percent,aes(x=landcover,y=percent_nov,fill=landcover)) +
  geom_col(show.legend = FALSE) +
  scale_fill_viridis_d(option = "viridis") +
  labs(y = "Percentage Cover in November 2019",
       x = "Landcover Type") +
  scale_y_continuous(limits = c(0,80)) +
  theme_classic()
  
percent_plot_nov

# the same for january
percent_plot_jan <- ggplot(percent,aes(x=landcover,y=percent_jan,fill=landcover)) +  
  geom_col(show.legend = FALSE) +
  scale_fill_viridis_d(option = "viridis") +
  labs(y = "Percentage Cover in January 2020",
       x = "Landcover Type") +
  scale_y_continuous(limits = c(0,80)) +
  theme_classic()

percent_plot_jan

# We can then view the two plots together to extrapolate some results
grid.arrange(percent_plot_nov, percent_plot_jan, nrow = 1)

dev.off()


# Normalised Difference Moisture Index (NDMI)
  
## Aim: to compare the moisture availability at the start of the main bushfire period in 2018, 2019 and 2020 
### Secondary Aim: to compare the moisture availability from early November to early February of the severe year 2019/20

### The (NDMI) is used to determine vegetation water content and monitor droughts, with a value range of -1 to 1
### Negative values of NDMI (values approaching -1) correspond to barren soil. 
### Values around zero (-0.2 to 0.4) generally correspond to water stress.
### High, positive values represent high canopy without water stress (approximately 0.4 to 1).

# To do this we compare the values of B8A, (useful for classifying vegetation) and B11 (useful for measuring moisture content of soil and vegetation, providing good contrasts)
par(mfrow = c(1,2))

moist_nov <- ((nov_stack[[6]] - nov_stack[[5]])/(nov_stack[[6]] + nov_stack[[5]]))

# In order to calculate the NDMI we import more data from Copernicus from the 01/11/2018
nov_2018_bands <- intersect(list.files(pattern = "2018-11"), list.files(pattern = "tiff"))
nov_2018_bands
nov_2018 <- nov_2018_bands %>% 
  rast() %>% 
  stack() %>% 
  crop(extent_mountains)
moist_nov_2018 <- ((nov_stack[[2]] - nov_stack[[1]])/(nov_stack[[2]] + nov_stack[[1]]))

# and also data from the  10/11/2018
nov_2020_bands <- intersect(list.files(pattern = "2020-11"), list.files(pattern = "tiff"))
nov_2020_bands
nov_2020 <- nov_2020_bands %>% 
  rast() %>% 
  stack() %>% 
  crop(extent_mountains)
moist_nov_2020 <- ((nov_stack[[2]] - nov_stack[[1]])/(nov_stack[[2]] + nov_stack[[1]]))

# Now we view all three years together, with the focal year November 2019 in the middle
par(mfrow = c(1,3))
plot(moist_nov_2018, col = inferno(256))
plot(moist_nov, col = inferno(256))
plot(moist_nov_2020, col = inferno(256))

# We then also calculate the NDMI for our january stack and have a look at the difference between before and after the bushfire of 2019/20
moist_jan <- ((jan_stack[[6]] - jan_stack[[5]])/(jan_stack[[6]] + jan_stack[[5]]))
plot(moist_jan, col = inferno(256))

dif_2020 = moist_jan - moist_nov
plot(dif_2020, col = inferno(256))


# In Conclusion, this simplified model has shown the severe effects that summer bushfires have on vegetation and moisture availability 
# It also indicates the extreme nature of the 2019/20 bushfires, pointing towards climate changes ever apparent effects on increasing the frequency and severity of natural disasters around the world
# Although this model shows quite a large difference in the moisture availability in 2019 it must be viewed with caution as there are many confounding factors
