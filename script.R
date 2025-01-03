if (!require(yahoofinancer)) install.packages("yahoofinancer")
if (!require(sjmisc)) install.packages("sjmisc")
if (!require(pastecs)) install.packages("pastecs")
if (!require(readODS)) install.packages("readODS")
if (!require(tidyr)) install.packages("tidyr")


library(yahoofinancer)
library(sjmisc)
library(pastecs)
library(readODS)
library(tidyr)

kghm <- Ticker$new("kgh.wa")$get_history(start="2014-10-01", interval="1mo")[,c("date", "adj_close")]
kghm <- kghm[1:(nrow(kghm)-2),]
kghm$adj_close <- as.double(kghm$adj_close)
btc <- Ticker$new("BTC-USD")$get_history(start="2014-10-01", interval="1mo")[,c("date", "adj_close")]
btc <- btc[1:(nrow(btc)-2),]
btc$adj_close <- as.double(btc$adj_close)
spy <- Ticker$new("SPY")$get_history(start="2014-10-01", interval="1mo")[,c("date", "adj_close")]
spy <- spy[1:(nrow(spy)-2),]
spy$adj_close <- as.double(spy$adj_close)
copper <- read_ods("./external-data.ods")[,c("Commodity","PCOPP")]
copper <- copper[300:nrow(copper),]
copper$PCOPP <- as.double(copper$PCOPP)

df_all = data.frame(
  date = spy[2:nrow(spy),"date"],
  kgh_lret = diff(log(kghm$adj_close), lag=1),
  spy_lret = diff(log(spy$adj_close), lag=1),
  btc_lret = diff(log(btc$adj_close), lag=1),
  cop_lret = diff(log(copper$PCOPP))
)

desc_stats <- descr(df_all)
