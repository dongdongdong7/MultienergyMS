devtools::document()
library(magrittr)
load("./test_data/CA.RData")
CA <- readr::read_csv("./test_data/CA.csv")
CA
ceRange1 <- c(5, 15)
ceRange2 <- c(15, 25)
ceRange3 <- c(25, 35)
rThreshold <- 0.2
noise <- 200
data1 <- CA %>%
  dplyr::filter(CE >= ceRange1[1] & CE <= ceRange1[2])
data1[, -1][data1[, -1] <= noise] <- NA
corMatrix1 <- round(cor(data1[, -1], use = "pairwise.complete.obs"), 2)
mz <- colnames(corMatrix1)
df1 <- dplyr::tibble(mz1 = double(), mz2 = double(), correlation = double())
for(mz1 in mz){
  for(mz2 in mz){
    correlation_tmp <- corMatrix1[mz1, mz2]
    df_tmp <- dplyr::tibble(mz1 = as.double(mz1),
                            mz2 = as.double(mz2),
                            correlation = correlation_tmp)
    df1 <- rbind(df1, df_tmp)
  }
}
df1$range <- 1

data2 <- CA %>%
  dplyr::filter(CE >= ceRange2[1] & CE <= ceRange2[2])
data2[, -1][data2[, -1] <= noise] <- NA
corMatrix2 <- round(cor(data2[, -1], use = "pairwise.complete.obs"), 2)
df2 <- dplyr::tibble(mz1 = double(), mz2 = double(), correlation = double())
for(mz1 in mz){
  for(mz2 in mz){
    correlation_tmp <- corMatrix2[mz1, mz2]
    df_tmp <- dplyr::tibble(mz1 = as.double(mz1),
                            mz2 = as.double(mz2),
                            correlation = correlation_tmp)
    df2 <- rbind(df2, df_tmp)
  }
}
df2$range <- 2

data3 <- CA %>%
  dplyr::filter(CE >= ceRange3[1] & CE <= ceRange3[2])
data3[, -1][data3[, -1] <= noise] <- NA
corMatrix3 <- round(cor(data3[, -1], use = "pairwise.complete.obs"), 2)
df3 <- dplyr::tibble(mz1 = double(), mz2 = double(), correlation = double())
for(mz1 in mz){
  for(mz2 in mz){
    correlation_tmp <- corMatrix3[mz1, mz2]
    df_tmp <- dplyr::tibble(mz1 = as.double(mz1),
                            mz2 = as.double(mz2),
                            correlation = correlation_tmp)
    df3 <- rbind(df3, df_tmp)
  }
}
df3$range <- 3

df <- rbind(df1, df2, df3) %>%
  dplyr::arrange(mz1)

demo <- paraSet(df = df, corThreshold = 0.6)
plotMultiMS(df = demo)
