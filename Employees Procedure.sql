CREATE PROC SP_ChanigInEmployees 
AS
BEGIN
	MERGE DIM_Employees AS Target
	USING STG_Employees AS Source
	ON Target.AgentID = Source.AgentID
	WHEN MATCHED AND Source.Status = 2 THEN UPDATE
	SET
		Target.AgentName = Source.FullName,
		Target.HireDate = Source.HireDate,
		Target.BirthDate = Source.BirthDate;
	Update Dim_Employees
	SET IsActive = 0
	FROM Dim_Employees dim
	JOIN STG_Employees stg ON dim.AgentID = stg.AgentID
	WHERE stg.Status = 3
END;