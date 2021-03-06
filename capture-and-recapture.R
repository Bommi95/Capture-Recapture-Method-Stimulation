#title: "Capture-recapture stimulation"

#author: "Juanjia Yuan"
#date: "8/28/2019"
#output: word_document

require(tidyverse)
require(gridExtra)


#question1
#generating sample n1
x.sim <- sample(1:5000, size=100, replace=FALSE)
x.sim
#generating sample n2
y.sim<-sample(1:5000,size=100,replace=FALSE)
y.sim
#checking numbers of m2
m<-as.numeric(length(y.sim[y.sim %in% x.sim]))

n1<-100
n2<-100

N<-(n1*n2)/m
N

#question2
#create a function that will return a dataframe that contain value from two vector m2 and NLP
simulate<-function(pop,num.sim=1000,
                   n1,n2){
  m2<-rep(NA,times=num.sim)
  NLP<-rep(NA,times=num.sim)
  n1=n2
  #create a loop to make the 1000 times iteration
  for(i in 1:num.sim){
    x.sim <- sample(1:pop, size=n1, replace=FALSE)
    y.sim <- sample(1:pop, size=n2, replace=FALSE)
    m2[i]<-as.numeric(length(y.sim[y.sim %in% x.sim]))
    NLP[i]<-(n1*n2)/m2[i]
    
    
  }
  df <- data.frame(m2,NLP)
  colnames(df) <- c("m value","LP estimator")
  return(df)
}

#call the simulate function
test1<-simulate(pop = 5000,num.sim=1000,
                n1=100,n2=100)
test1

#building ggplot histogram

theme.info <- theme(plot.title = element_text(size=14, hjust=0.5),
                    axis.title = element_text(size=12),
                    axis.text.y=element_text(size=12),
                    axis.text.x = element_text(size=12),
                    legend.title=element_blank(),
                    legend.position="top")


hist.1 <- test1 %>% ggplot(aes(test1$`LP estimator`)) +
  geom_histogram(aes(y=..ndensity..), bins=30) +
  ggtitle("Histogram of Simulated N=5000 Data") +
  labs(x=expression(paste("simulated LP estimated population value, N=5000 data", sep=""))) +
  theme.info 

hist.1

#question3
#we replace Infinite number with 0
test1[test1==Inf]<-0
test1$"LP estimator"
#generate a frequency table to show the frequency of value 0 in the test1
freqtable<-table(test1$"LP estimator")
freqtable
"148 Inf values,14.8% of the estimated population value are infinte"

"why the Inf occur?"
"Because for each iteration that has m=0
(the samples in n1 and n2 has no value in common.Nothing found in n2 is tagged ), 
the denomnator of the LP formula equals to zero, thurs the result is infinite "

#question4


#building a for loop to apply chapman estimator
NC<-rep(NA,times=1000)
n1<-100
n2<-100
test1m<-as.numeric(test1$`m value`)

for (i in 1:length(test1m)){
  NC[i]<-((n1+1)*(n2+1))/(test1$`m value`[i]+1) - 1
  
}
NC<-data.frame(NC)


hist.2 <- NC %>% ggplot(aes(NC)) +
  geom_histogram(aes(y=..density..), bins=50) +
  ggtitle("Histogram of Chapman Simulated N=5000 Data") +
  labs(x=expression(paste("simulated Chapman estimated population value, N=5000 data", sep=""))) +
  theme.info 

hist.2
#question5

#sample average of the N Lincoln peterson and N chapman value

test1[test1==Inf]<-0
#we did 1000 times of stimulation
num.sim<-1000

samplemeanLP<-sum(as.numeric(test1$"LP estimator"))/num.sim
samplemeanLP

samplemeanCH<-sum(as.numeric(NC$NC))/num.sim
samplemeanCH

#calculate each estimator's bias E[^theta] -E[theta]= 0
N=5000
biasLP<- samplemeanLP - N
#show the bias is Lincoln Peterson estimator
biasLP
#show the bias is Chapman estimator
biasCH<- samplemeanCH - N
biasCH

#question6
#Based on my findings, Lincoln peterson estimator is less bias than the chapman estimator

#question7
#(a) if one fish is captured, the activity might drove other individual in the population away. In reality it is really hard to prevent the event a occurs does not affect the probability of B occurring
#(b) for example, A bag is full of cards having different colors and sizes and we draw a card ramdomly. The probability of all the cards will not be the same. Probability of occurrence of each card will vary
#(c) "for example, taking animal sample in the population from a natural environment, inevitably theres individual will experience death,birth,immigration. so close population is not realistic"