library(RPostgreSQL)

drv <- dbDriver("PostgreSQL")
con1 <- dbConnect(drv, host="redshift-cluster-1.c3sygq87tdc2.us-east-2.redshift.amazonaws.com", 
                  port="5439",
                  dbname="dev", 
                  user="awsuser", 
                  password="Dusty2014!")
con1

df_postgres <- dbGetQuery(con1, "SELECT * from thesis.rides_201601 limit 100 ")
df_postgres