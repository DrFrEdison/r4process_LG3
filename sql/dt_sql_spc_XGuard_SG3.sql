USE XGuard
GO
SELECT TOP 100 systemMainParameters.location
	,systemMainParameters.line 
	,measurement.Batch.ID
    ,measurement.Measurement.startedAt AS [DateTime]
    ,dbo.MeasurementType.code AS measurementTypeCode
    ,dbo.ProductVariant.PCSnumber AS MixerNumber
    ,dbo.product.number AS DTproductNumber
    ,dbo.product.name AS DTproductName
    ,MeasurandValueCaffeine.yValue AS caffeine
    ,ModelParaCaffeine.[fileName] as caffeineUNSB 
    ,ModelParaCaffeine.modelName as caffeineModel
    ,ModelResultCaffeine.yPredictedCorr as caffeineyPredictedCorr
    ,ModelResultCaffeine.yPredicted as caffeineyPredicted
    ,ModelResultCaffeine.yDeviation as caffeineyDeviation
    ,ModelResultCaffeine.scores as caffeinescores
    ,ModelResultCaffeine.hotellingsT2 as caffeinehotellingsT2
    ,ModelResultCaffeine.hotellingsT2Lim as caffeinehotellingsT2Lim
    ,ModelResultCaffeine.fResidualsXSample as caffeinefResidualsXSample
    ,ModelResultCaffeine.fResidualsLim as caffeinefResidualsLim
--    ,ModelResultCaffeine.qResidualsXSample as caffeineqResidualsXSample
--    ,ModelResultCaffeine.qResidualsLim as caffeineqResidualsLim
    ,MeasurandValueTotalAcid.yValue AS totalAcid
    ,ModelParaTotalAcid.[fileName] as totalAcidUNSB 
    ,ModelParaTotalAcid.modelName as totalAcidModel
    ,ModelResultTotalAcid.yPredictedCorr as totalAcidyPredictedCorr
    ,ModelResultTotalAcid.yPredicted as totalAcidyPredicted
    ,ModelResultTotalAcid.yDeviation as totalAcidyDeviation
    ,ModelResultTotalAcid.scores as totalAcidscores
    ,ModelResultTotalAcid.hotellingsT2 as totalAcidhotellingsT2
    ,ModelResultTotalAcid.hotellingsT2Lim as totalAcidhotellingsT2Lim
    ,ModelResultTotalAcid.fResidualsXSample as totalAcidfResidualsXSample
    ,ModelResultTotalAcid.fResidualsLim as totalAcidfResidualsLim
--    ,ModelResultTotalAcid.qResidualsXSample as totalAcidqResidualsXSample
--    ,ModelResultTotalAcid.qResidualsLim as totalAcidqResidualsLim
    ,MeasurandValueGs2.yValue AS GS2
    ,ModelParaGs2.[fileName] as GS2UNSB
    ,ModelParaGs2.modelName as GS2Model
    ,ModelResultGs2.yPredictedCorr as GS2yPredictedCorr
    ,ModelResultGs2.yPredicted as GS2yPredicted
    ,ModelResultGs2.yDeviation as GS2yDeviation
    ,ModelResultGs2.scores as GS2scores
    ,ModelResultGs2.hotellingsT2 as GS2hotellingsT2
    ,ModelResultGs2.hotellingsT2Lim as GS2hotellingsT2Lim
    ,ModelResultGs2.fResidualsXSample as GS2fResidualsXSample
    ,ModelResultGs2.fResidualsLim as GS2fResidualsLim
--  ,ModelResultGs2.qResidualsXSample as GS2qResidualsXSample
--  ,ModelResultGs2.qResidualsLim as GS2qResidualsLim
    ,MeasurandValueBrix.yValue AS brix
    ,MeasurandValueDiet.yValue AS diet
    ,MeasurandValueCO2.yValue AS co2
    ,MeasurandValueConductivity.yValue AS conductivity
    ,[status].[timestamp] AS statusTimestamp
    ,PressureTable.valueNumeric AS FluidPressure
    ,FlowTable.valueNumeric AS FluidFlow
    ,TempFluidTable.valueNumeric AS FluidTemperature
    ,SPCTempTable.valueNumeric AS SpectrometerTemperature
    ,TempRackTable.valueNumeric AS RackTemperature
    ,TempAmbientTable.valueNumeric AS AmbientTemperature
    ,measurement.Spectrum.[timestamp] AS spectrumTimestamp
    ,systemCell.lightPath
    ,systemCell.transferFunctionCoef
    ,measurement.SpectrumConfig.integrationTime
    ,method.Cell.accumulations
    ,REPLACE    (    (SELECT CAST(measurement.SpectrumValues.value AS varchar)+';'
                        FROM measurement.SpectrumValues
                        WHERE measurement.SpectrumValues.spectrumID=measurement.Spectrum.ID
                        ORDER BY wavelength ASC
                        FOR XML PATH('')
                    )
                    , '.', ','
                ) AS absSpectrum_csv
FROM measurement.Measurement
LEFT JOIN measurement.Spectrum ON (measurement.Spectrum.measurementID=measurement.Measurement.ID)
LEFT JOIN measurement.SpectrumConfig ON (measurement.Spectrum.spectrumConfigID = measurement.SpectrumConfig.ID)
LEFT JOIN method.Cell ON (measurement.SpectrumConfig.metCellID = method.Cell.ID)
LEFT JOIN [system].Cell as systemCell ON (measurement.SpectrumConfig.sysCellID = systemCell.ID)
LEFT JOIN [system].[Main] as systemMainParameters ON measurement.Measurement.systemID = systemMainParameters.ID
LEFT JOIN dbo.MeasurementType ON dbo.MeasurementType.ID = Measurement.measurementTypeID
LEFT JOIN measurement.Batch ON (measurement.Measurement.batchID=measurement.Batch.ID)
LEFT JOIN dbo.ProductVariant ON (measurement.Batch.productVariantID=dbo.ProductVariant.ID)
LEFT JOIN dbo.Product ON (dbo.ProductVariant.productID=dbo.Product.ID)

 

 

 

LEFT JOIN 
    (measurement.MeasurandValue as MeasurandValueCaffeine 
    INNER JOIN measurement.MeasurandConfig as MeasurandConfigCaffeine ON (MeasurandValueCaffeine.measurandConfigID=MeasurandConfigCaffeine.ID)
    INNER JOIN dbo.MeasurandConfig AS dboMeasurandConfigCaffeine ON (MeasurandConfigCaffeine.dboMeasurandConfigID=dboMeasurandConfigCaffeine.ID AND dboMeasurandConfigCaffeine.measurandID = 1) --caffeine
    INNER JOIN measurement.Model AS ModelResultCaffeine ON (MeasurandValueCaffeine.ID=ModelResultCaffeine.measurandID)
    INNER JOIN method.Model AS ModelParaCaffeine ON (ModelResultCaffeine.metModel=ModelParaCaffeine.ID)
    ) ON (measurement.Measurement.ID=MeasurandValueCaffeine.measurementID)

 

 

 

LEFT JOIN 
    (measurement.MeasurandValue as MeasurandValueTotalAcid 
    INNER JOIN measurement.MeasurandConfig as MeasurandConfigTotalAcid ON (MeasurandValueTotalAcid.measurandConfigID=MeasurandConfigTotalAcid.ID)
    INNER JOIN dbo.MeasurandConfig AS dboMeasurandConfigTotalAcid ON (MeasurandConfigTotalAcid.dboMeasurandConfigID=dboMeasurandConfigTotalAcid.ID AND dboMeasurandConfigTotalAcid.measurandID = 2) -- total acid
    INNER JOIN measurement.Model AS ModelResultTotalAcid ON (MeasurandValueTotalAcid.ID=ModelResultTotalAcid.measurandID)
    INNER JOIN method.Model AS ModelParaTotalAcid ON (ModelResultTotalAcid.metModel=ModelParaTotalAcid.ID)
    ) ON (measurement.Measurement.ID=MeasurandValueTotalAcid.measurementID)

 

LEFT JOIN 
    (measurement.MeasurandValue as MeasurandValueGs2 
    INNER JOIN measurement.MeasurandConfig as MeasurandConfigGs2 ON (MeasurandValueGs2.measurandConfigID=MeasurandConfigGs2.ID)
    INNER JOIN dbo.MeasurandConfig AS dboMeasurandConfigGs2 ON (MeasurandConfigGs2.dboMeasurandConfigID=dboMeasurandConfigGs2.ID AND dboMeasurandConfigGs2.measurandID = 8) -- cp2
    INNER JOIN measurement.Model AS ModelResultGs2 ON (MeasurandValueGs2.ID=ModelResultGs2.measurandID)
    INNER JOIN method.Model AS ModelParaGs2 ON (ModelResultGs2.metModel=ModelParaGs2.ID)
    ) ON (measurement.Measurement.ID=MeasurandValueGs2.measurementID)

 

LEFT JOIN 
    (measurement.MeasurandValue as MeasurandValueBrix 
    INNER JOIN measurement.MeasurandConfig as MeasurandConfigBrix ON (MeasurandValueBrix.measurandConfigID=MeasurandConfigBrix.ID)
    INNER JOIN dbo.MeasurandConfig AS dboMeasurandConfigBrix ON (MeasurandConfigBrix.dboMeasurandConfigID=dboMeasurandConfigBrix.ID AND dboMeasurandConfigBrix.measurandID = 14) -- brix
    ) ON (measurement.Measurement.ID=MeasurandValueBrix.measurementID)

 

 

 

LEFT JOIN 
    (measurement.MeasurandValue as MeasurandValueDiet 
    INNER JOIN measurement.MeasurandConfig as MeasurandConfigDiet ON (MeasurandValueDiet.measurandConfigID=MeasurandConfigDiet.ID)
    INNER JOIN dbo.MeasurandConfig AS dboMeasurandConfigDiet ON (MeasurandConfigDiet.dboMeasurandConfigID=dboMeasurandConfigDiet.ID AND dboMeasurandConfigDiet.measurandID = 7) -- diet
    ) ON (measurement.Measurement.ID=MeasurandValueDiet.measurementID)

 

 

 

LEFT JOIN 
    (measurement.MeasurandValue as MeasurandValueCO2 
    INNER JOIN measurement.MeasurandConfig as MeasurandConfigCO2 ON (MeasurandValueCO2.measurandConfigID=MeasurandConfigCO2.ID)
    INNER JOIN dbo.MeasurandConfig AS dboMeasurandConfigCO2 ON (MeasurandConfigCO2.dboMeasurandConfigID=dboMeasurandConfigCO2.ID AND dboMeasurandConfigCO2.measurandID = 5) -- co2
    ) ON (measurement.Measurement.ID=MeasurandValueCO2.measurementID)

 

 

 

LEFT JOIN 
    (measurement.MeasurandValue as MeasurandValueConductivity 
    INNER JOIN measurement.MeasurandConfig as MeasurandConfigConductivity ON (MeasurandValueConductivity.measurandConfigID=MeasurandConfigConductivity.ID)
    INNER JOIN dbo.MeasurandConfig AS dboMeasurandConfigConductivity ON (MeasurandConfigConductivity.dboMeasurandConfigID=dboMeasurandConfigConductivity.ID AND dboMeasurandConfigConductivity.measurandID = 6) -- conductivity
    ) ON (measurement.Measurement.ID=MeasurandValueConductivity.measurementID)

 

 

 

LEFT JOIN [status].[Status] ON (measurement.Measurement.statusID=[status].[Status].ID)
LEFT JOIN [status].ProcessDataValue AS SPCTempTable ON (measurement.Measurement.statusID=SPCTempTable.statusID AND SPCTempTable.ProcessDataID=3)
LEFT JOIN [status].ProcessDataValue AS FlowTable ON (measurement.Measurement.statusID=FlowTable.statusID AND FlowTable.ProcessDataID=2)
LEFT JOIN [status].ProcessDataValue AS PressureTable ON (measurement.Measurement.statusID=PressureTable.statusID AND PressureTable.ProcessDataID=1)
LEFT JOIN [status].ProcessDataValue AS TempFluidTable ON (measurement.Measurement.statusID=TempFluidTable.statusID AND TempFluidTable.ProcessDataID=4)
LEFT JOIN [status].ProcessDataValue AS TempRackTable ON (measurement.Measurement.statusID=TempRackTable.statusID AND TempRackTable.ProcessDataID=6)
LEFT JOIN [status].ProcessDataValue AS TempAmbientTable ON (measurement.Measurement.statusID=TempAmbientTable.statusID AND TempAmbientTable.ProcessDataID=5)
WHERE MeasurementType.code IN (0,1,2,16,65536) --- for codes execute SELECT query to dbo.MeasurementType Table
    AND measurement.startedAt BETWEEN 'YYYY-MM-DD HH:MM:SS_t0' AND 'YYYY-MM-DD HH:MM:SS_t1' --Timestamp filter by batch
    -- AND Product.number=1 --for numbers execute SELECT query to dbo.Product Table
	AND  (MeasurandValueCaffeine.yValue is not NULL OR MeasurandValueTotalAcid.yValue is not NULL or MeasurandValueGs2.yValue IS NOT NULL OR MeasurandValueBrix.yValue IS NOT NULL)
ORDER BY Measurement.ID DESC