
Execute_Procedure = function(modelbinstr,modelname,modeltype,description,version,author){
  exec = "exec [dbo].[Xente_model] "
  query = paste(exec,"@m='", modelbinstr, "'",  ",",
    "@modelname = '", modelname, "' ,",
    "@modeltype = '", modeltype, "' ,",
    "@modeldescription = '", description, "' ,",
    "@modelversion = '", version, "' ,",
    "@author = '", author, "' ;",
    sep = ""
  )
  query
}
### Serialize the model 
modelbin = serialize(model, NULL)
modelbinstr = paste(modelbin, collapse = "")
### Excute the procedure and Store the model
execstr = Execute_Procedure(modelbinstr,"DECISION_TREE_MODEL",
                            "Classification", "Xente Fraud Detection",
                            1.0,"Holar"
                            )
##connect to your server and upload the model and test data
library(RODBC)
server <- "yourservername"
database<- "yourdatabase"
username <- "username"
password <- "password"
connectionString <- paste0("Driver={SQL Server};server=",server,";database=",database,";trusted_connection=yes;")

channel <-  odbcDriverConnect(connection=connectionString,rows_at_time = 1)
## upload the model
upload = sqlQuery(channel,execstr, errors = TRUE,rows_at_time = 1)
### upload test data to SQL 
sqlSave(channel,df_test,tablename = "xente_test", rownames = F)



