#' Association Algorithm Study
#' Package: arules, arulesViz
#' Hsuan-Chun Lin

#install.packages("arules")
#install.packages("arulesViz")

library(arules)
library(arulesViz)
#import data

data <- read.csv("21ABC rk ave summary-U.csv", header=T)

#Before we start, we need to discretize our data if they are numerical.
#lgkon.dis <- discretize(log(koff[,2]), categories=4)
#lgka.dis <- discretize(log(koff[,3]), categories=4)
#koff.dis <- discretize(koff[,4], categories=4)
#MFE.dis <- discretize(MFE.filter[,2], categories = 4)

#rkA.dis <- cut(log(data[,2]), breaks = seq(-10,10, by = 10), labels = c("LOW","HIGH"))
#rkB.dis <- cut(log(data[,3]), breaks = seq(-10,10, by = 10), labels = c("LOW","HIGH"))
#rkC.dis <- cut(log(data[,4]), breaks = seq(-10,10, by = 10), labels = c("LOW","HIGH"))
#MFE.dis <- cut(MFE.filter[,2], breaks = seq(-105,-5, by = 100), labels = c("HIGH","LOW"))\

#handle data < 0
c <- data[,2] <= 0
data[c,2] <- 0.0001
c <- data[,3] <= 0
data[c,3] <- 0.0001
c <- data[,4] <= 0
data[c,4] <- 0.0001
rkA.dis <- discretize(log(data[,2]), breaks=2)
rkB.dis <- discretize(log(data[,3]), breaks=2)
rkC.dis <- discretize(log(data[,4]), breaks=2)
MFEA.dis <- discretize(abs(data[,5]), breaks=2)
MFEB.dis <- discretize(abs(data[,6]), breaks=2)
MFEC.dis <- discretize(abs(data[,7]), breaks=1)

#TableForAnalysis <- data.frame(cbind(rkA.dis, rkB.dis, rkC.dis, MFEA.dis, MFEB.dis, MFEC.dis))
#TableForAnalysis$Sequence <- data[,1]
#colnames(TableForAnalysis) <- c("rkA.dis", "rkB.dis", "rkC.dis", "MFEA.dis", "MFEB.dis", "MFEC.dis")

TableForAnalysis <- data.frame(cbind(rkA.dis, rkB.dis,rkC.dis, MFEA.dis,MFEB.dis))
TableForAnalysis$Sequence <- data[,1]
colnames(TableForAnalysis) <- c("rkA.dis", "rkB.dis", "rkC.dis", "MFEA.dis","MFEB.dis")



str(TableForAnalysis)
#Why do we need to use str

# find association rules with default settings
AnalysisTable <- TableForAnalysis[,1:5]

# To do it for all names
col_names <- names(AnalysisTable)
# do do it for some names in a vector named 'col_names'
AnalysisTable[,col_names] <- lapply(AnalysisTable[,col_names] , factor)


#sum(!is.finite(AnalysisTable))

rules <- apriori(AnalysisTable)
inspect(rules)

# rules with rhs containing "lnkon" only
rules <- apriori(AnalysisTable,
                parameter = list(minlen=2, supp=0.001, conf=0.5),
                appearance = list(rhs=c("rkC.dis = 1", "rkC.dis = 2", "rkC.dis = 3"),
                                  default="lhs"),
                control = list(verbose=F))

rules.sorted <- sort(rules, by="lift")
inspect(rules.sorted)

# find redundant rules
subset.matrix <- is.subset(rules.sorted, rules.sorted)
subset.matrix[lower.tri(subset.matrix, diag=T)] <- NA
redundant <- colSums(subset.matrix, na.rm=T) >= 1
which(redundant)
# remove redundant rules
rules.pruned <- rules.sorted[!redundant]
inspect(rules.pruned)


plot(rules)
plot(rules, method="graph", control=list(type="items"))
plot(rules, method="paracoord", control=list(reorder=TRUE))
plot(rules, method="matrix3D", measure="lift")
plot(rules, method="matrix", measure="lift", control=list(reorder=FALSE))
plot(rules, method="grouped")

data.ana = data[data$X21B.1.6 >= 0.8 & data$MFEB < -7,]
