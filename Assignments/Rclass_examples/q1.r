num_samples <- 50000
v <- rexp(num_samples, 0.2)
x <- data.frame(X = seq(1, num_samples , 1), Y = sort(v))
plot(x)
u <- split(v,1:500)
m <- rep(1,500)
s <- rep(1,500)

for(i in 1:5){
	pdf <- rep(0, 35);
	vec <- unlist(u[i], use.names=FALSE)
	for(j in 1:100){
		val <- round(vec[j])
		if(val <= 35){
	       pdf[val] = pdf[val] + 1/100; 
	    }
	}
	xcols <- c(0:34)
	plot(xcols, pdf, "l", xlab="X", ylab="f(X)")
	m[i] <- mean(vec)
	s[i] <- sd(vec)
}

for(i in 1:5){
	cdf <- rep(0, 35);
	cdf[1] <- pdf[1]
	for(j in 2:35){
	    cdf[j] <- cdf[j-1] + pdf[j]
	}
	plot(xcols, cdf, "o", col="blue", xlab="X", ylab="F(X)");
}

for(i in 6:500){
	vec <- unlist(u[i], use.names=FALSE)
	m[i] <- mean(vec)
	s[i] <- sd(vec)	
}

for(i in 1:5){
  print(m[i])
  print(s[i])
}


tab <- table(round(m))

str(tab)
plot(tab, "h", xlab="Mean", ylab="Frequency")

pdf <- rep(0, 35);

for(i in 1:500){
  val=round(m[i], 0);
  if(val <= 35){
    pdf[val] = pdf[val] + 1/500; 
  }
}

plot(xcols, pdf, "l", xlab="Mean", ylab="PDF")

cdf <- rep(0, 35)

cdf[1] <- pdf[1]

for(i in 2:35){
  cdf[i] = cdf[i-1] + pdf[i]
}

plot(xcols, cdf, "o", col="blue", xlab="Mean", ylab="CDF");


fmean <- mean(m)
fsd <- mean(s)
donot <- sd(m)

print(fmean)
print(fsd)
print(donot)
