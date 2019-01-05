data <- read.csv("21ABC rk ave summary-U.csv", header = T)
data.jing <- read.csv("21B-3-8_rk_ave.csv",header = T)
data38 <- read.csv("ABECEQMFE.csv", heade = T)

# filter the sequence to match ULF's data
data.new <- data.jing[data.jing$Sequence %in% data38$seq,]
data38$RKB <- data.new$rk

#process data -1 to -6
fil.1 <- data[data$X21A.1.6 > 0.8,]
dil.2 <- fil.1[fil.1$MFEA <= -7,]

write.csv(dil.2, "Result_A.csv")
fil.1B <- data[data$X21B.1.6 > 0.8,]
dil.2B <- fil.1B[fil.1B$MFEB <= -7,]
write.csv(dil.2B, "Result_B.csv")

#Process data -3 - -8
data.fi38A <- data38[data38$RK > 0.8, ]
data.fi2.38A <- data.fi38A[data.fi38A$MFEA <= -7,]
write.csv(data.fi2.38A, "Result_38A.csv")
data.fi38B <- data38[data38$RKB > 1, ]
data.fi2.38B <- data.fi38B[data.fi38B$MFEB <= -7,]
write.csv(data.fi2.38B, "Result_38B.csv")
