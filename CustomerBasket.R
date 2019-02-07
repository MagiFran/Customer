
library(plyr)
library(arules)
library(lubridate)
library(tidyverse)



CustomerPurchases <- read.csv("D:/Data_Input/Customer/CustomerPurchases.csv")


CustomerBasket <- ddply(CustomerPurchases, "CustomerID",
                      function(df1)paste(df1$Product,
                                         collapse = ","))


#Null Customer Number

CustomerBasket$CustomerID <- NULL


#Label Product Column

colnames(CustomerBasket) <- c("Product")

#Write to working directory
write.csv(CustomerBasket, "D:/Data_Input/Customer/CustomerBasketCategories.csv", quote = FALSE, row.names = TRUE)

#Read from working directory
CustomerTrans <- read.transactions('D:/Data_Input/Customer/CustomerBasketCategories.csv', format = 'basket', sep=',')


# Min Support as 0.001, confidence as 0.8.
main.association.rules <- apriori(CustomerTrans, parameter = list(supp=0.001, conf=0.8 ,maxlen=4))

summary(main.association.rules)

inspect(main.association.rules)




