﻿IF NOT EXISTS(SELECT NULL
              FROM information_schema.columns
              WHERE table_name = 'KEP_Logger'
                AND column_name = 'PACK_SANDWICH')
   ALTER TABLE [dbo].[KEP_logger] ADD [PACK_SANDWICH] [bit]  NULL
GO

SET NUMERIC_ROUNDABORT OFF;
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON;
GO

IF OBJECT_ID ('dbo.v_ScalesDetailInfo',N'V') IS NOT NULL
   DROP VIEW dbo.[v_ScalesDetailInfo];
GO

CREATE VIEW [dbo].v_ScalesDetailInfo
AS
SELECT ww.EquipmentID as ID,
       ww.[Description] as ScalesName,
       ww.WEIGHT_CURRENT,
       ww.WEIGHT_STAB,
       ww.WEIGHT_ZERO,
       ww.AUTO_MANU,
       ww.POCKET_LOC,
       ww.PACK_SANDWICH,
       CAST(0 as bit) as ALARM,
       ww.COUNT_BAR RodsQuanity,
       ww.REM_BAR RodsLeft 
FROM (
SELECT eq.ID EquipmentID,
       eq.[Description],
       ROW_NUMBER() OVER(PARTITION BY kl.[NUMBER_POCKET] ORDER BY kl.[TIMESTAMP] DESC) RowNumber,
       kl.[WEIGHT_CURRENT],
       kl.[WEIGHT_STAB],
       kl.[WEIGHT_ZERO],
       kl.[COUNT_BAR],
       kl.[REM_BAR],
       kl.[AUTO_MANU],
       kl.[POCKET_LOC],
       kl.[PACK_SANDWICH]
FROM dbo.Equipment eq
     INNER JOIN dbo.EquipmentProperty eqp ON (eqp.EquipmentID=eq.ID)
     INNER JOIN dbo.EquipmentClassProperty ecp ON (ecp.ID=eqp.ClassPropertyID AND ecp.value=N'CONTROLLER_NO')
     INNER JOIN dbo.KEP_logger kl ON (ISNUMERIC(eqp.value)=1 AND kl.[NUMBER_POCKET]=CAST(eqp.value AS INT) AND kl.[TIMESTAMP]>=DATEADD(hour,-1,GETDATE()))
) ww
WHERE ww.RowNumber=1;
GO