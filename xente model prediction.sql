Declare @model as VARBINARY(MAX) = 
   (SELECT TOP 1 model FROM [dbo].[Xente_model_table]
   WHERE modelname = 'DECISION_TREE_MODEL' and modelversion = 1.0
   )


 
 
---if table does not exist
	IF OBJECT_ID('dbo.Xente_Prediction', 'U') IS NULL
		BEGIN
   CREATE TABLE dbo.Xente_Prediction (
    --model VARBINARY(MAX),
	id int identity (1,1),
	TransactionID NVARCHAR(100),
	AccountId NVARCHAR(100),
	Amount NUMERIC,
	Value NUMERIC,
	Prediction FLOAT,
	Classification NVARCHAR(100),
	insertdate datetime
	);

	END

   INSERT INTO dbo.Xente_Prediction
   EXECUTE sp_execute_external_script
		@language = N'R',
		@script = N'

		library(rpart)
		
		### the input data
		data = InputDataSet
		

		id = data$TransactionID
		data$TransactionID = NULL

		### MODELLING
		mod.xgb= unserialize(as.raw(model));
		pred = predict(mod.xgb, newdata = data)[,2];
		out_label = ifelse(pred>0.5,"Accept","Reject")
		## OUTPUT DATA		
		output = data.frame(
		TransactionID = id,
		AccountID = data$AccountId,
		Amount = data$Amount,
		Value = data$Value,
		prediction = pred,
		label = out_label,
		time = Sys.time()
		)

		OutputDataSet = output
		'
	,@input_data_1 = N' SELECT * FROM dbo.xente_test;'
	,@params = N' @model VARBINARY(MAX)'
	,@model = @model



  --select * from dbo.Rmodel_table2