library(tidyverse)


CustomerList <- unique(CustomerPurchases$CustomerID)

Sample.Customer <- head(CustomerList, 100)

Sample.Purchases <- CustomerPurchases %>% 
  filter(CustomerID %in% Sample.Customer)




Sample.Customer$CalendarDate <- as.Date(Sample.Customer$CalendarDate)


# this needs work

#Sample.df <- Sample.Purchases %>%
#  arrange(Product) %>%
#  select(-TrxCode) %>%
#  unique() %>%
#  group_by(CustomerID, Region, CalendarDate) %>%
#  summarise(cart=paste(Product,collapse=";")) %>%
#  ungroup()
#


#states and average purchase
x.max.date <- max(sample.df$CalendarDate)+1
x.ids <- unique(sample.df$CustomerID)
sample.df.new <- data.frame()



for (i in 1:length(x.ids)) {
  sample.df.cache <- sample.df %>%
    filter(CustomerID==x.ids[i])
  
  ifelse(nrow(sample.df.cache)==1,
         av.dur <- 180,
         av.dur <- round(((max(sample.df$CalendarDate) - min(sample.df$CalendarDate))/(nrow(sample.df.cache)-1))*1.5, 0))
  
  sample.df.cache <- rbind(sample.df.cache, data.frame(Host_ContactId=sample.df.cache$Host_ContactId[nrow(sample.df.cache)], CountryKey=sample.df.cache$CountryKey[nrow(sample.df.cache)], CalendarDate=max(sample.df.cache$CalendarDate)+av.dur, cart='nopurch'))
  ifelse(max(sample.df.cache$CalendarDate) > x.max.date, sample.df.cache$CalendarDate[which.max(sample.df.cache$CalendarDate)] <- x.max.date, NA)
  
  sample.df.cache$to <- c(sample.df.cache$CalendarDate[2:nrow(sample.df.cache)]-1, x.max.date)
  
  # order# for Sankey diagram
  sample.df.cache <- sample.df.cache %>%
    mutate(ord = paste('ord', c(1:nrow(sample.df.cache)), sep=''))
  
  sample.df.new <- rbind(sample.df.new, sample.df.cache)
}


# filtering dummies
df.new <- df.new %>%
  filter(cart!='nopurch' | to != orderdate)
#rm(orders, df, df.cache, i, ids, max.date, av.dur)



df.new <- df.new %>%
  # chosing a length of sequence
  filter(ord %in% c('ord1', 'ord2', 'ord3', 'ord4')) %>%
  select(-ord)

# converting dates to numbers
min.date <- as.Date(min(df.new$orderdate), format="%Y-%m-%d")
df.new$orderdate <- as.numeric(df.new$orderdate-min.date+1)
df.new$to <- as.numeric(df.new$to-min.date+1)


#write.csv(OnyxCustomerPurchases,"OnyxCustomerPurchases")





