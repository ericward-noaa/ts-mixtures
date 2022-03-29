
n=100
y1=arima.sim(list(ar=(0.5)), n=n)
y2=cumsum(rnorm(n, -0.2, 1))
val=rbind(y1,y2)
loc=sample(1:2, n, replace=TRUE, prob=c(2/3, 1/3))
ixc <- 1:n
ixr <- loc
y = val[(ixc-1)*nrow(val)+ixr]
