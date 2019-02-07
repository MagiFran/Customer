library("arules")

set.seed(101)
orders <- data.frame(
  transactionID = sample(1:500, 1000, replace=T),
  item = paste("item", sample(1:50, 1000, replace=T),sep = "")
)

head(orders,10)


###method 1 via CSV file##############
# Using a CSV ####
# Create a temporary directory
dir.create(path = "tmp", showWarnings = FALSE)

# Write our data.frame to a csv
write.csv(orders, "./tmp/tall_transactions.csv")

# Read that csv back in
order_trans <- read.transactions(
  file = "./tmp/tall_transactions.csv",
  format = "single",
  sep = ",",
  cols=c("transactionID","item"),
  rm.duplicates = T
)
summary(order_trans)



###method 2  direct in R##############

# Converting to a Matrix ####
orders$const = TRUE

# Remove duplicates
dim(orders) #1,000 x 3
orders <- unique(orders)
dim(orders) #979 x 3


# Need to reshape the matrix
orders_mat_prep <- reshape(data = orders,
                           idvar = "transactionID",
                           timevar = "item",
                           direction = "wide")

# Drop the transaction ID
order_matrix <- as.matrix(orders_mat_prep[,-1])

# Clean up the missing values to be FALSE
order_matrix[is.na(order_matrix)] <- FALSE


# Clean up names
colnames(order_matrix) <- gsub(x=colnames(order_matrix),
                               pattern="const\\.", replacement="")



order_trans2 <- as(order_matrix,"transactions")



