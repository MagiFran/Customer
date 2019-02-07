## Use this preparation method to avoid the export-import step for large data sets.



CustomerBasket2 <- CustomerPurchases[,c(1,3)]

CustomerBasket2 <- unique(CustomerBasket2)


CustomerBasket2$const = TRUE


CustomerBasket3 <- reshape(data = CustomerBasket2,
                           idvar = "CustomerID",
                           timevar = "Product",
                           direction = "wide")

# Clean up names
colnames(CustomerBasket3) <- gsub(x=colnames(CustomerBasket3),
                               pattern="const\\.", replacement="")

# Clean up the missing values to be FALSE
CustomerBasket3[is.na(CustomerBasket3)] <- FALSE


#Remove Miscellaneous Category

CustomerBasketTrans <- as.matrix(CustomerBasket3[,-1])







CustomerBasketTrans <- as(CustomerBasketTrans, "transactions")

# Min Support as 0.001, confidence as 0.65 length as 4
main.association.rules <- apriori(CustomerTrans, parameter = list(supp=0.001, conf=0.65,maxlen=4))

summary(main.association.rules)


inspect(main.association.rules)

