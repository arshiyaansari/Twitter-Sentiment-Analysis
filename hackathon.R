install.packages("SnowballC")
install.packages("tm")
install.packages("twitteR")
install.packages("syuzhet")
install.packages("wordcloud")

library("SnowballC")
library("tm")
library("twitteR")
library("syuzhet")
library("stringr")
library("wordcloud")


consumer_key = "Zw5cQNtd0rEXVnaQz0qACzD72"
consumer_secret = "Hy0OtEfwa4Mlp5ll4nTwWr8P5juHpA6sccCHdFZs4Km9ZoMIbf"
access_token = "2596885015-zHpPQ6MYow9Q3J39IM4jsWYLRmGFAULwwGutUzl"
access_secret = "HFVhI8AtGpHL1D8KIEp1A5cy2rxeHJmRzD7Fu3dEaiD1f"
# consumer_key = "PJ1v0CNlENGRWij2XqkSVqd6c"
# consumer_secret = "vtjH0vETnmU07r0KLFrS9BfhZQWrWemd8ricIuO5Fwb1KrybWM"
# access_token = "1019291391678124033-K0xOmNP19kwTQSV2lBkpa1HQl99Sz7"
# access_secret = "9weqcmTa60BD3HP6kxrWxefZmmOlbzoVZzNFbpYfODJ55"
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)

(tweets <- searchTwitter('juul', n = 3200, since = "2018-09-22", until = "2018-09-23"))
tweets
help(searchTwitter)

tweets.df <- twListToDF(tweets) 

tweets.df2 <- gsub("http.*","",tweets.df$text)

tweets.df2 <- gsub("https.*","",tweets.df2)

tweets.df2 <- gsub("#.*","",tweets.df2)

tweets.df2 <- gsub("(RT )?@\\S*","",tweets.df2)
tweets.df2
word.df <- as.vector(tweets.df2)
word2.df = unlist(word.df)
emotion.df <- get_nrc_sentiment(word2.df)
emotion.df
emotion2.df <- get_sentiment(word2.df)
write.csv(emotion2.df, file = "22.csv")

most.positive <- word2.df[emotion2.df == max(emotion2.df)]

most.positive
most.negative <- word2.df[emotion2.df == min(emotion2.df)]
most.negative

(cigs <- searchTwitter("cigarettes", n = 3200, since = "2018-09-20", until = "2018-09-21"))
# tweets1
cigs.df <- twListToDF(cigs) 

cigs.df2 <- gsub("http.*","",cigs.df$text)

cigs.df2 <- gsub("https.*","",cigs.df2)

cigs.df2 <- gsub("#.*","",cigs.df2)

cigs.df2 <- gsub("(RT )?@\\S*","",cigs.df2)
w3.df <- as.vector(cigs.df2)
w4.df = unlist(w3.df)
emotion3.df <- get_nrc_sentiment(w4.df)
emotion3.df
emotion4.df <- get_sentiment(w4.df)
emotion4.df
most.positive <- w4.df[emotion4.df == max(emotion4.df)]

most.positive
most.negative <- w4.df[emotion4.df == min(emotion4.df)]
most.negative
write.csv(emotion2.df, file = "20CIGS.csv")

