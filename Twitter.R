# twitteR API
library(twitteR)
consumer_key = "Zw5cQNtd0rEXVnaQz0qACzD72"
consumer_secret = "Hy0OtEfwa4Mlp5ll4nTwWr8P5juHpA6sccCHdFZs4Km9ZoMIbf"
access_token = "2596885015-zHpPQ6MYow9Q3J39IM4jsWYLRmGFAULwwGutUzl"
access_secret = "HFVhI8AtGpHL1D8KIEp1A5cy2rxeHJmRzD7Fu3dEaiD1f"
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)

(JUUL <- searchTwitter("juul", n = 3200))
JUUL.tweets = do.call(rbind, lapply(JUUL, as.data.frame))

(cigs <- searchTwitter("\\bcig\\b|\\bcigarette|\\bcigs\\b", n = 3200))
cigs.tweets = do.call(rbind, lapply(cigs, as.data.frame))

write_delim(JUUL.tweets, "ramhacks/juul_tweets.csv", delim = "|")
write_delim(cigs.tweets, "ramhacks/cigs_tweets.csv", delim = "|")

library(SnowballC)
library(tm)
library(syuzhet)

JUUL.tweets2 <- gsub("http.*", "", JUUL.tweets$text)
JUUL.tweets2 <- gsub("https.*", "", JUUL.tweets2)
JUUL.tweets2 <- gsub("(RT )?@\\S* ", "", JUUL.tweets2)
JUUL.tweets2 <- gsub("\n", " ", JUUL.tweets2)
JUUL.tweets2 <- gsub("[“”]", "'", JUUL.tweets2)
JUUL.tweets2 <- gsub("[’…]", "", JUUL.tweets2)
JUUL.tweets2

JUUL.emotion <- get_nrc_sentiment(JUUL.tweets2)
JUUL.emotion <- cbind(text = JUUL.tweets2, JUUL.emotion, sentiment = get_sentiment(JUUL.tweets2))
head(JUUL.emotion)
write_delim(JUUL.emotion, "ramhacks/juul_sentiments.csv", delim = "|", col_names = FALSE)

cigs.tweets2 <- gsub("http.*", "", cigs.tweets$text)
cigs.tweets2 <- gsub("https.*", "", cigs.tweets2)
cigs.tweets2 <- gsub("(RT )?@\\S* ", "", cigs.tweets2)
cigs.tweets2 <- gsub("\n", " ", cigs.tweets2)
cigs.tweets2 <- gsub("[“”]", "'", cigs.tweets2)
cigs.tweets2 <- gsub("[’…]", "", cigs.tweets2)
cigs.tweets2

cigs.emotion <- get_nrc_sentiment(cigs.tweets2)
cigs.emotion <- cbind(text = cigs.tweets2, cigs.emotion, sentiment = get_sentiment(cigs.tweets2))
head(cigs.emotion)
write_delim(cigs.emotion, "ramhacks/cigs_sentiments.csv", delim = "|", col_names = FALSE)


# JUUL --------------------------------------------------------------------

JUUL.emotion <- read_delim("ramhacks/juul_sentiments.csv", delim = "|", col_names = 
                             c("text", "anger", "anticipation", "disgust", "fear", "joy", "sadness", 
                               "surprise", "trust", "negative", "positive", "sentiment"))

JUUL.vector <- VectorSource(JUUL.emotion$text)
JUUL.corpus <- Corpus(JUUL.vector)
JUUL.corpus <- tm_map(JUUL.corpus, content_transformer(tolower))
JUUL.corpus <- tm_map(JUUL.corpus, content_transformer(removePunctuation))
JUUL.corpus <- tm_map(JUUL.corpus, stemDocument)
JUUL.corpus <- tm_map(JUUL.corpus, removeWords, stopwords("english"))

JUUL.dtm <- DocumentTermMatrix(JUUL.corpus)
sort(colSums(as.matrix(JUUL.dtm))) %>% tail

JUUL.tfidf <- DocumentTermMatrix(JUUL.corpus, control = list(weighting = weightTfIdf)) %>% as.matrix
JUUL.tfidf

# library(ggplot2)
# ggplot(data.frame(term = names(ft), occurrences = ft)) +
#   geom_bar( aes(term, occurrences), stat = "identity") +
#   theme(axis.text.x=element_text(angle = 45, hjust = 1))
ft <- tail(sort(colSums(as.matrix(JUUL.dtm))), 100)

library(wordcloud)
require(RColorBrewer)
wordcloud(names(ft), log(ft), min.freq = 20, colors = brewer.pal(8, "Dark2"))

# Cigarettes --------------------------------------------------------------

cigs.emotion <- read_delim("ramhacks/cigs_sentiments.csv", delim = "|", col_names = 
                            c("text", "anger", "anticipation", "disgust", "fear", "joy", "sadness", 
                              "surprise", "trust", "negative", "positive", "sentiment"))

cigs.vector <- VectorSource(cigs.emotion$text)
cigs.corpus <- Corpus(cigs.vector)
cigs.corpus <- tm_map(cigs.corpus, content_transformer(tolower))
cigs.corpus <- tm_map(cigs.corpus, content_transformer(removePunctuation))
cigs.corpus <- tm_map(cigs.corpus, stemDocument)
cigs.corpus <- tm_map(cigs.corpus, removeWords, stopwords("english"))

cigs.dtm <- DocumentTermMatrix(cigs.corpus)
sort(colSums(as.matrix(cigs.dtm))) %>% tail

ft <- tail(sort(colSums(as.matrix(cigs.dtm))), 100)

cigs.tfidf <- DocumentTermMatrix(cigs.corpus, control = list(weighting = weightTfIdf)) %>% as.matrix

wordcloud(names(ft), log(ft), min.freq = 20, colors = brewer.pal(8, "Dark2"))



# analysis ----------------------------------------------------------------

setwd("downloads")
files <- list.files(pattern = "\\d\\dCIGS(-1)?.csv")
asdf <- do.call(rbind, lapply(files[-1], read_csv))

mean(asdf$x)


sdfg <- read_csv("juuldata.csv")
mean(sdfg$x)
