CREATE PROCEDURE Xente_Model
(
@m				NVARCHAR(MAX),
@modelname		NVARCHAR(100),
@modeltype		NVARCHAR(100),
@modeldescription NVARCHAR(MAX),
@modelversion	  FLOAT,
@author			 NVARCHAR(100))
as
begin


---if table does not exist
	IF OBJECT_ID('dbo.Xente_model_table', 'U') IS NULL

	BEGIN

	CREATE TABLE dbo.Xente_model_table
	(
	model VARBINARY(MAX),
	modelname NVARCHAR(100),
	modeltype NVARCHAR(100),
	modeldescription NVARCHAR(MAX),
	modelversion FLOAT,
	author NVARCHAR(MAX),
	insertdate datetime
	);

	END
	--

	--select * from Rmodel_table
	SET NOCOUNT ON;

	INSERT INTO dbo.Xente_model_table(model, modelname,modeltype,modeldescription, modelversion, author,insertdate)
	VALUES(
	CONVERT(VARBINARY(MAX), @m ,2),
	@modelname,
	@modeltype,
	@modeldescription,
	@modelversion,
	@author,
	GETDATE()
	)

	END


	--select * from dbo.Xente_model_table
	--select * from dbo.xente_test_data