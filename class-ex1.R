## load the necessary packages
library(ggplot2)
library(dplyr)

## define the function
condition.factor <- function(w,l){
  cond.fact <- 100*(w/l^3)
  return(cond.fact)
}

## take out all NA's
dat2 <- dat %>% filter(!is.na(ungutted.weight))
## call the first length value using []
dat2$length[1]
## call the first ungutted weight value using[]
dat2$ungutted.weight[1]

## put in the numbers
condition.factor(380,35)
## the same but calling the numbers instead
condition.factor(dat2$ungutted.weight[1],
                 dat2$length[1])
                 
## swapping the inputs
condition.factor(l=dat2$length[1],
                 w=dat2$ungutted.weight[1])

## Assign condition factor to all weighted fish using mutate
dat2 <- 
  dat2 %>%
  mutate(cond = condition.factor(l=length,w=ungutted.weight),
         cond.2 = 100*ungutted.weight/length^3)

## select cond and cond.2 for comparison and 
## restrict to the first 10 lines
dat2 %>% select(cond,cond.2) %>% slice(1:10)

## using for - loops
dat2 <- mutate(dat2,cond.for = NA)

for(i in 1:nrow(dat2)){
  dat2$cond.for[i] <- 
    condition.factor(dat2$ungutted.weight[i],
                     dat2$length[i])
}

