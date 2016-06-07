﻿SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID(N'dbo.getCurrentPerson', N'FN') IS NOT NULL
    DROP FUNCTION dbo.getCurrentPerson;
GO
CREATE FUNCTION dbo.getCurrentPerson
(
)
RETURNS INT
WITH EXECUTE AS CALLER
AS
     BEGIN
         DECLARE @PersonID INT;
         SELECT @PersonID = p.ID
         FROM dbo.Person p,
              dbo.PersonProperty pp,
              dbo.PersonnelClassProperty pcp
         WHERE pp.PersonID = p.ID
               AND pcp.Value = 'AD_LOGIN'
               AND pcp.ID = pp.ClassPropertyID
               AND pp.Value = SYSTEM_USER;
         RETURN(@PersonID);
     END;
GO