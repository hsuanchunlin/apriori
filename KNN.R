data <- read.csv("summary_dirfit.csv", header = T)
mydata <- data[,c(8,15,16,17)]
mydata.s <- scale(mydata)

plot(mydata.s[,3], mydata.s[,4])

# Determine number of clusters
wss <- (nrow(mydata)-1)*sum(apply(mydata,2,var))
for (i in 2:15) wss[i] <- sum(kmeans(mydata,
                                     centers=i)$withinss)
plot(1:15, wss, type="b", xlab="Number of Clusters",
     ylab="Within groups sum of squares") 

# K-Means Cluster Analysis
fit <- kmeans(mydata, 5) # 5 cluster solution
# get cluster means
aggregate(mydata,by=list(fit$cluster),FUN=mean)
# append cluster assignment
mydata <- data.frame(mydata, fit$cluster) 

mydata$sequence = data$sequence

write.csv(mydata, "KNN-result.csv")
colors = c("red","blue", "orange", "green", "yellow")

library(ggplot2)

g <- ggplot(data = mydata)
g <- g+geom_point(aes(x = RKAAVG.A, y = MFEA, color = fit.cluster))
g

data_A <- data[data$RKAAVG.A > 0.8,]
data_A <- data_A[data_A$MFEA < -7,]
