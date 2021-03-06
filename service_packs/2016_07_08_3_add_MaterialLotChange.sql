﻿SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID('dbo.v_MaterialLotChange', N'V') IS NOT NULL
    DROP VIEW dbo.[v_MaterialLotChange];
GO

CREATE VIEW [dbo].[v_MaterialLotChange]
AS
     WITH MaterialLotProperties
          AS (SELECT mlp.[ID],
                     mlp.[MaterialLotID],
                     pt.[Value] PropertyType,
                     mlp.[Value]
              FROM [dbo].[MaterialLotProperty] mlp
                   INNER JOIN [dbo].[PropertyTypes] pt ON(pt.[ID] = mlp.[PropertyType]))
          SELECT ml.ID,
                 ml.FactoryNumber,
                 ml.CreateTime,
                 ml.Quantity,
          (
              SELECT [Value]
              FROM MaterialLotProperties
              WHERE MaterialLotID = ml.Id
                    AND PropertyType = 'PROD_ORDER'
          ) PROD_ORDER,
          (
              SELECT [Value]
              FROM MaterialLotProperties
              WHERE MaterialLotID = ml.Id
                    AND PropertyType = 'PART_NO'
          ) PART_NO,
          (
              SELECT [Value]
              FROM MaterialLotProperties
              WHERE MaterialLotID = ml.Id
                    AND PropertyType = 'BUNT_NO'
          ) BUNT_NO,
                 CAST(0 AS BIT) selected
          FROM (SELECT ml.[ID],
                                  ml.[FactoryNumber],
                                  ml.[Status],
                                  ml.[Quantity],
						    ml.CreateTime,
                                  ROW_NUMBER() OVER (PARTITION BY ml.[FactoryNumber] ORDER BY ml.[CreateTime] DESC, ml.[ID] DESC) RowNumber
                           FROM [dbo].[MaterialLot] ml) ml
                     WHERE ml.RowNumber=1;
GO      

