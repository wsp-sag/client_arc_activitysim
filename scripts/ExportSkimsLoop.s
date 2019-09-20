RUN PGM=MATRIX
  RECI=skim_manifest.csv, DELIMITER=',' Token=1,FFile(C)=2,Matrix=3,TimePeriod=4,SORT=FFile
  PRINTO[1]=convert_to_omx_skims.s
  IF(RECI.RECNO>1)
    IF(RECI.RECNO=2)
      finalSkim = RI.FFile
      OUTTRUE=1
    ELSE
      IF(RI.FFile<>finalSkim) 
        OUTTRUE=1 
        finalSkim = RI.FFile
      ELSE 
        OUTTRUE=0
        finalSkim = RI.FFile
      ENDIF
    ENDIF
    origSkimName = REPLACESTR(finalSkim,'.omx','.skm',1)
    str1 = 'CONVERTMAT FROM="C:\Projects\ARC_188800A\Tasks\ActivitySim\CubeSkims\'
    str2 = '" FORMAT=OMX COMPRESSION=7'
    IF (OUTTRUE=1) PRINT LIST=str1,origSkimName,'" TO="..\output\',finalSkim,str2 PRINTO=1
  ENDIF
ENDRUN								
*runConvertSkim.cmd