

##Question #5
#normally distributed with mean 10.5 weeks and stdev =1.8 weeks

# A.
1 - pnorm(8, 10.5, 1.8)

# B. 
qnorm(c(0.10, 0.90), 10.5, 1.8)

# C.
pnorm(9, 10.5, 1.8 / sqrt(40))


#Q6
#A binom
dbinom(3, 7, 0.6)

#B
1 - dbinom(1, 7,0.6)

#C
mean_used <- 7 * 0.6
sd_used <- sqrt(7 * 0.6 * 0.4)
mean_used
sd_used

###Question7 
x_bar <- 2440       
s <- 170            
n <- 20             
alpha <- 0.05      

SE <- s / sqrt(n)
SE

crit_score <- qt(1 - alpha/2, df = n - 1)
crit_score

MOE <- crit_score * SE
MOE

lower_bound <- x_bar - MOE
upper_bound <- x_bar + MOE
c(lower_bound, upper_bound)


###Question8
phat1 <- 0.36
phat2 <- 0.60

n1 <- 100
n2 <- 100

p_pool <- (phat1 * n1 + phat2 * n2) / (n1 + n2)
SE <- sqrt(p_pool * (1 - p_pool) * (1/n1 + 1/n2))
t <- (phat1 - phat2) / SE
pval <- 2 * pnorm(-abs(z))

SE
z
pval

# Question 9
t.test(weight ~ gender, data = locusts, var.equal = FALSE)

# Question 10
model = lm(weight ~ length, data=locusts)
summary(model)

r = sqrt(0.8301)
