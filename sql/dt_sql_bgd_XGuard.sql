SELECT TOP 100000 systemMainParameters.location
	,systemMainParameters.line 
	,measurement.Batch.ID
	,measurement.Measurement.startedAt AS [timestamp]
	,dbo.MeasurementType.code AS measurementTypeCode
	,dbo.ProductVariant.PCSnumber AS MixerNumber
	,dbo.product.number AS DTproductNumber
	,dbo.product.name AS DTproductName
    ,[status].[timestamp] AS statusTimestamp
	,PressureTable.valueNumeric AS FluidPressure
	,FlowTable.valueNumeric AS FluidFlow
	,TempFluidTable.valueNumeric AS FluidTemperature
	,SPCTempTable.valueNumeric AS SpectrometerTemperature
	,TempRackTable.valueNumeric AS RackTemperature
	,TempAmbientTable.valueNumeric AS AmbientTemperature
	,systemCell.lightPath
	,systemCell.transferFunctionCoef
	,measurement.SpectrumConfig.integrationTime
	,method.Cell.accumulations
	
	,BGDSpectrumTable.[timestamp] AS spectrumTimestampBGD
    ,REPLACE	(	(SELECT CAST(measurement.SpectrumValues.value AS varchar)+';'
						FROM measurement.SpectrumValues
						WHERE measurement.SpectrumValues.spectrumID=BGDSpectrumTable.ID
						ORDER BY wavelength ASC
						FOR XML PATH('')
					)
					, '.', ','
				) AS BGDSpectrum_csv
				
FROM measurement.Measurement
LEFT JOIN measurement.Spectrum as BGDSpectrumTable ON (BGDSpectrumTable.measurementID=measurement.Measurement.ID AND BGDSpectrumTable.[type] = 1)
LEFT JOIN measurement.SpectrumConfig ON (BGDSpectrumTable.spectrumConfigID = measurement.SpectrumConfig.ID)
LEFT JOIN measurement.Spectrum as DRKSpectrumTable ON (DRKSpectrumTable.measurementID=measurement.Measurement.ID AND DRKSpectrumTable.[type] = 0)
LEFT JOIN method.Cell ON (measurement.SpectrumConfig.metCellID = method.Cell.ID)
LEFT JOIN [system].Cell as systemCell ON (measurement.SpectrumConfig.sysCellID = systemCell.ID)
LEFT JOIN [system].[Main] as systemMainParameters ON measurement.Measurement.systemID = systemMainParameters.ID
LEFT JOIN dbo.MeasurementType ON dbo.MeasurementType.ID = Measurement.measurementTypeID
LEFT JOIN measurement.Batch ON (measurement.Measurement.batchID=measurement.Batch.ID)
LEFT JOIN dbo.ProductVariant ON (measurement.Batch.productVariantID=dbo.ProductVariant.ID)
LEFT JOIN dbo.Product ON (dbo.ProductVariant.productID=dbo.Product.ID)

LEFT JOIN [status].[Status] ON (measurement.Measurement.statusID=[status].[Status].ID)
LEFT JOIN [status].ProcessDataValue AS SPCTempTable ON (measurement.Measurement.statusID=SPCTempTable.statusID AND SPCTempTable.ProcessDataID=3)
LEFT JOIN [status].ProcessDataValue AS FlowTable ON (measurement.Measurement.statusID=FlowTable.statusID AND FlowTable.ProcessDataID=2)
LEFT JOIN [status].ProcessDataValue AS PressureTable ON (measurement.Measurement.statusID=PressureTable.statusID AND PressureTable.ProcessDataID=1)
LEFT JOIN [status].ProcessDataValue AS TempFluidTable ON (measurement.Measurement.statusID=TempFluidTable.statusID AND TempFluidTable.ProcessDataID=4)
LEFT JOIN [status].ProcessDataValue AS TempRackTable ON (measurement.Measurement.statusID=TempRackTable.statusID AND TempRackTable.ProcessDataID=6)
LEFT JOIN [status].ProcessDataValue AS TempAmbientTable ON (measurement.Measurement.statusID=TempAmbientTable.statusID AND TempAmbientTable.ProcessDataID=5)
WHERE MeasurementType.code IN (4096) --- for codes execute SELECT query to dbo.MeasurementType Table
AND measurement.startedAt BETWEEN 'YYYY-MM-DD HH:MM:SS_t0' AND 'YYYY-MM-DD HH:MM:SS_t1' --Timestamp filter by batch
	-- AND Product.number=1 --for numbers execute SELECT query to dbo.Product Table
ORDER BY Measurement.ID ASC
