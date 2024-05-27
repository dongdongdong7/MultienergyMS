devtools::document()
#load("./test_data/CA.RData")
#CA <- readr::read_csv("./test_data/CA.csv")

data(CA)
df <- cal_cor(CA, max_CE = 45, ceLength = 10, noise = 1000)
df <- paraSet(df, corThreshold = 0.8)
plotMultiMS(df = df, scale_size = c(4, 10),stroke = 0.5)
