CREATE PROC SP_ChangeInCustomers
AS
BEGIN
	MERGE DIM_Customers AS Target
	USING STG_Customers AS Source
	ON Target.CustomerID = Source.CustomerID
	WHEN MATCHED AND (Source.CustomerName <> Target.CustomerName OR Source.Address <> Target.Address OR
	Source.City <> Target.City OR Source.StateName <> Target.Region OR Source.Country <> Target.Country)
		THEN UPDATE
			SET Target.CustomerName = Source.CustomerName ,
				Target.Address = Source.Address,
				Target.City = Source.City,
				Target.Region = Source.StateName,
				Target.Country = Source.Country,
				Target.UpdateDate = GETDATE()

	WHEN NOT MATCHED BY Target THEN INSERT (CustomerID,CustomerName,Address,City,Region,Country,IsActive,UpdateDate)
		VALUES (Source.CustomerID,Source.CustomerName,Source.Address,Source.City,Source.StateName,Source.Country,1,GETDATE())

	WHEN NOT MATCHED BY Source THEN UPDATE SET Target.IsActive = 0, Target.UpdateDate = GETDATE();
END;
