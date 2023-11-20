SELECT 
	Mea_Measurements.ID
	,[DateTime_Start]
	,User_Start
	, User_Results
      ,[MeasurementType] as Messungstyp
      ,[SampleName] as Mustername
	  ,stage as Stufe
	  ,label as Etikettenummer
      ,[AttemptNumber] as Ansatznummer
	  ,AnalysisMethod as Methode
	  ,PrevM_AnalysisMethod as lezte_Methode
	  ,[UNSB_Name] as Unscmablerdatei
	  ,BGD_Medium
	  ,BGD_MediumText
	  ,BGD_Validity
	  ,MethodType
	  ,PrevM_MethodType
	  ,ProcessSolvent
	  ,PrevM_ProcessSolvent
	  ,Mea_ModelsInfo.ModelName as Modell
	  ,MEA_Table.Average AS Mittelung
	  ,MEA_Table.[Light_path] as Pfadlänge
	  ,MEA_Analyte.Reported_Value
	  ,Mea_Analyte.Analyte
	  ,Mea_Analyte.Analyte_Unit
	  ,Mea_Analyte.Alarm_LO
	  ,Mea_Analyte.Alarm_UP
	  ,Mea_Analyte.Warning_LO
	  ,Mea_Analyte.Warning_UP
	  ,Mea_Analyte.Specification
	  ,Result_Analyte
	  ,Mea_ModelsInfo.Scores as Scores
	  ,Mea_ModelsInfo.Y_Predicted as YPredicted
	  ,Mea_ModelsInfo.YDeviation as YDeviation
	  ,Mea_ModelsInfo.Y_Predicted_Corr as YPred_korrigiert
	  ,Mea_ModelsInfo.Bias as Bias
	  ,Mea_ModelsInfo.Hotellingt2 as Hotellingt2
	  ,Mea_ModelsInfo.Hotellingt2Lim as Hotellingt2Lim
	  ,Mea_ModelsInfo.FResXSamp as FResXSamp
	  ,Mea_ModelsInfo.FResLims as FResLims
	  ,MEA_Table.IntegrationTime as Integrationszeit
	,ABS_Table.Spectrum_Abs AS [ABS]
	,BGD_Table.Spectrum_Raw AS BGD
	,DRK_Table.Spectrum_Raw as DRK

	FROM [dbo].[Mea_Measurements]
  left join Mea_Analyte as MEA_Analyte on Mea_Analyte.Measurement_ID = Mea_Measurements.ID
  left join Mea_ModelsInfo on Mea_ModelsInfo.Analyte_ID = Mea_Analyte.ID
    left join Mea_Spectrums as MEA_Table on Mea_ModelsInfo.Spectrum_MEA_ID = MEA_Table.ID
  left join Mea_Spectrums as BGD_Table on MEA_Table.Spectrum_BGD = BGD_Table.ID
  left join Mea_Spectrums as DRK_Table on MEA_Table.Spectrum_DRK = DRK_Table.ID
  left join Mea_SPCFiles as ABS_Table on ABS_Table.Spectrum_MEA_ID = MEA_Table.ID
  WHERE Cancelled = 0
  order by Mea_Measurements.ID DESC