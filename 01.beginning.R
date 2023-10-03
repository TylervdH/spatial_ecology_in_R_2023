# you are effectively now in an R document as you have named the file with a .R suffix, this means that the hashtag works the same and this line is not read


# insert some random code


# array
sophi <- c(10,20,30,50,70)  # microplastics as arguments inside the vector function 
sophi

paula <- c(100, 500, 600, 1000, 2000) # people
paula

plot(paula, sophi, xlab = "no. of people", ylab = "microplastics")

people <- paula
microplastics <- sophi

plot(people, microplastics, pch = 2) # this pch changes the point character to the designated symbol:number combination
plot(people, microplastics, pch = 4, cex = 2)
plot(people, microplastics, pch = 4, cex = 2, col = "blue")


# PART 2

install.packages("sp")
library(sp)




