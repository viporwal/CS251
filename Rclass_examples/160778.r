num_samples <- 50000
v <- rexp(num_samples, 0.2)
x <- data.frame(X = seq(1, num_samples , 1), Y = sort(v))
plot(x,main="Scatter Plot")
u <- split(v,1:500)
m <- rep(1,500)
s <- rep(1,500)

for(i in 1:5){
	vec <- unlist(u[i], use.names=FALSE)
	plot(density(vec),main=paste("PDF for vector",i))
	plot(ecdf(vec),main=paste("CDF for vector",i))
	m[i] <- mean(vec)
	s[i] <- sd(vec)
}

for(i in 6:500){
	vec <- unlist(u[i], use.names=FALSE)
	m[i] <- mean(vec)
	s[i] <- sd(vec)	
}

for(i in 1:5){
  cat("Mean for vector ",i,": ",m[i],"\n")
  cat("Standard Deviation for vector ",i,": ",s[i],"\n")
}

hist(m,density=30,main="Frequency for means")

plot(density(m),main="PDF for distribution of means")

plot(ecdf(m),main="CDF for distribution of means")


fmean <- mean(m)
fsd <- sd(m)

cat("Mean for vector of means: ",fmean,"\n")
cat("Standard Deviation for vector of means: ",fsd,"\n")
