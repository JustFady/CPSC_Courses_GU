#MY FIRST R SCRIPT - BY FADY YOUSSEF AND 

#Using R as a calculator 

4+7+3 # 14
5*8*3 # 120
(6^5) # 7776
sqrt(390) # 19.74842
 
#after continuing to run, the thing object becomes defined with the given value
# then it is called when typed "thing" giving us back the value
# then thing +2 updates the value to 122 
thing <-5*8*3 # 120
thing
thing + 2


My.name <- "Fady" #declare value to object 
My.name

All.names <- c("Bob", "Ryan", "Sarah", "Maria")
All.names

Miles.per.day <- c(3,0,4.5,0,3,3,0)
Miles.per.day

x= seq(1,15)
y=c(-2,1,0,0,1)
2*x+y # 0  5  6  8 11 10 15 16 18 21 20 25 26 28 31
2*(x+y) # -2  6  6  8 12  8 16 16 18 22 18 26 26 28 32

ages <- c(40,19,12,35,18,25,31,55,70,70,21,20)
sort(ages) #
mean(ages) #
median(ages) #
quantile(ages) #

fivenum(ages) #this puts the value of the min, max, and functions above into a function

x= sample(1:100, size=20)
y=sample(1:100, size=20)
x
y

stem(x)
  stem(x,scale=2)
  hist(x)
  hist(x,breaks=10)
  hist(x,breaks=10, freq=F, lines(density(x)))
  boxplot(x)
  boxplot(x,y)
  
#Using mtcars data set 
  mtcars
  
  nrow(mtcars)
  ncol(mtcars)
  mtcars$mpg
  mean(mtcars$mpg) #mpg columns from dataset 
  median(mtcars$mpg)
  min(mtcars$mpg)
  
  min(mpg) #no dataset or associated object 
  mean(mpg)