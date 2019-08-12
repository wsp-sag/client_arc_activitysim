;{lastin,editbox,"Last Internal Before Externals",N,"5922"}

;-------------------------------------------------------------
; Create Accessibility File
;-------------------------------------------------------------
; 20december2007 [dto-pb]
; 10november2008 [jh] revised for ARC and two write 10 fields for auto/transit * pk/op * tot/retail, and non-motor * tot/retail
; 09april2009 [bts] revised to use the same calculations as were used for the estimation
; 29july2013 [jln] revised to use midday highway/transit skims and revised transit skims
	 ; script is located in project runtime folder, so data file locations are relative to the runtime folder.
	 ; sovpk=sov peak, sovff=sov offpeak, wlklpk=walk local bus peak, wlklop=walk local bus offpeak, 
	 ; wlkppk=walk premium peak, wlkpop=wlk premium offpeak
RUN PGM=MATRIX
 MATI[1] = sov_free_am.skm
 MATI[2] = sov_free_md.skm
 MATI[3] = wlk_alltrn_wlk_am.skm  ;wlklpk.skm
 MATI[4] = wlk_alltrn_wlk_md.skm  ;wlklop.skm
 MATI[5] = wlk_prmtrn_wlk_am.skm  ;wlkppk.skm
 MATI[6] = wlk_prmtrn_wlk_md.skm  ;wlkpop.skm
 ZDATI   = ZoneData.dbf,z=ZONE

   ; set debug values (_debug=1 is on switch)
   _debug = 1
   _debugOrig = 2172
   _debugDest = 2394
   
   ; set the dispersion parameters
   _kAuto = -0.05
   _kTran = -0.05
   _kWalk = -1.0
   
   ; set maximum non-motorized distance
   _maxNmDistance = 3.0
   
   ; write header
   if(i==1)
      list = "taz,autoPeakRetail,autoPeakTotal,autoOffPeakRetail,autoOffPeakTotal,transitPeakRetail,transitPeakTotal,transitOffPeakRetail,transitOffPeakTotal,nonMotorizedRetail,nonMotorizedTotal", file=accessibility.csv
   endif 
   
   ; initialize origin loop sum
   sumAuPkRetail = 0.0
   sumAuPkTotal = 0.0
   sumAuOpRetail = 0.0
   sumAuOpTotal = 0.0
   sumTrPkRetail = 0.0
   sumTrPkTotal = 0.0
   sumTrOpRetail = 0.0
   sumTrOpTotal = 0.0
   sumNmRetail = 0.0
   sumNmTotal = 0.0
   
  ;tabulate transit tables by OVT/IVT
 ;AM - ALL TRANSIT
   MW[31]=MI.3.WALK+MI.3.IWAIT+MI.3.XWAIT                                           ;AM OVT
   MW[32]=MI.3.WALK.T+MI.3.IWAIT.T+MI.3.XWAIT.T                                     ;AM OVT - TRANSPOSED
   MW[33]=MI.3.LOCAL+MI.3.XBUS+MI.3.HRT+MI.3.BRT+MI.3.LRT+MI.3.COMRAIL              ;AM IVT   
   MW[34]=MI.3.LOCAL.T+MI.3.XBUS.T+MI.3.HRT.T+MI.3.BRT.T+MI.3.LRT.T+MI.3.COMRAIL.T  ;AM IVT - TRANSPOSED
 ;MD - ALL TRANSIT
   MW[41]=MI.4.WALK+MI.4.IWAIT+MI.4.XWAIT                                           ;MD OVT
   MW[42]=MI.4.WALK.T+MI.4.IWAIT.T+MI.4.XWAIT.T                                     ;MD OVT - TRANSPOSED
   MW[43]=MI.4.LOCAL+MI.4.XBUS+MI.4.HRT+MI.4.BRT+MI.4.LRT+MI.4.COMRAIL              ;MD IVT   
   MW[44]=MI.4.LOCAL.T+MI.4.XBUS.T+MI.4.HRT.T+MI.4.BRT.T+MI.4.LRT.T+MI.4.COMRAIL.T  ;MD IVT - TRANSPOSED
 ;AM - PREMIUM TRANSIT
   MW[51]=MI.5.WALK+MI.5.IWAIT+MI.5.XWAIT                                           ;AM OVT
   MW[52]=MI.5.WALK.T+MI.5.IWAIT.T+MI.5.XWAIT.T                                     ;AM OVT - TRANSPOSED
   MW[53]=MI.5.LOCAL+MI.5.XBUS+MI.5.HRT+MI.5.BRT+MI.5.LRT+MI.5.COMRAIL              ;AM IVT   
   MW[54]=MI.5.LOCAL.T+MI.5.XBUS.T+MI.5.HRT.T+MI.5.BRT.T+MI.5.LRT.T+MI.5.COMRAIL.T  ;AM IVT - TRANSPOSED
 ;MD - PREMIUM TRANSIT
   MW[61]=MI.6.WALK+MI.6.IWAIT+MI.6.XWAIT                                           ;MD OVT
   MW[62]=MI.6.WALK.T+MI.6.IWAIT.T+MI.6.XWAIT.T                                     ;MD OVT - TRANSPOSED
   MW[63]=MI.6.LOCAL+MI.6.XBUS+MI.6.HRT+MI.6.BRT+MI.6.LRT+MI.6.COMRAIL              ;MD IVT   
   MW[64]=MI.6.LOCAL.T+MI.6.XBUS.T+MI.6.HRT.T+MI.6.BRT.T+MI.6.LRT.T+MI.6.COMRAIL.T  ;MD IVT - TRANSPOSED
   ; loop through each destinaton
   jloop
   
     ; get the destination zone retail employment from dbf file
     retailEmp = zi.1.RETAIL[j] + zi.1.SERVICE[j]
     totalEmp = zi.1.EMP[j]
     
     ;default values
     auPkRetail = 0.0
     auOpRetail = 0.0
     trPkRetail = 0.0
     trOpRetail = 0.0
     nmRetail = 0.0
     auPkTotal = 0.0
     auOpTotal = 0.0
     trPkTotal = 0.0
     trOpTotal = 0.0
     nmTotal = 0.0

        ; auto - tables are: (1=toll, 2=distance, 3=time)
        auPkTime = (mi.1.time[j] + mi.1.time.T[j]) ;/100.0
        auOpTime = (mi.2.time[j] + mi.2.time.T[j]) ;/100.0
        auPkRetail = retailEmp * exp(_kAuto * auPkTime)
        auOpRetail = retailEmp * exp(_kAuto * auOpTime)
        auPkTotal = totalEmp * exp(_kAuto * auPkTime)
        auOpTotal = totalEmp * exp(_kAuto * auOpTime)
        
        ; transit - tables are: 1=wlkt 2=autt 3=iwait 4=xwait 5=loc 6=artexp 7=artbrt 8=rail 9=xbus 
        ; 10=pbrt 11=crail 12=xfers 13=fare 14=tottime 15=xferwt 16=firstmode 17=farelinks 18=premflag 19=trnivt 20=dist 21=trndist
        
        ; transit - tables are: 1=walk 2=iwait 3=xwait 4=local 5=xbus 6=hrt 7=brt 8=lrt 9=comrail 10=brds 11=fare 12=xpen 13=ivt

        ; am peak transit
        ltt = 2*(MW[31]+MW[32]) + (MW[33]+MW[34])   ;2*OVT + IVT
        ptt = 2*(MW[51]+MW[52]) + (MW[53]+MW[54])   ;2*OVT + IVT
        
        ltt2= MW[31]+MW[32]+MW[33]+MW[34]   ;OVT + IVT
        ptt2= MW[51]+MW[52]+MW[53]+MW[54]   ;OVT + IVT

        if(ltt>0) 
         if(ltt<ptt)
            trPkRetail = retailEmp * exp(_kTran * ltt2) ;/100.0)
            trPkTotal = totalEmp * exp(_kTran * ltt2) ;/100.0)
         endif
        else
          if(ptt>0)
            trPkRetail = retailEmp * exp(_kTran * ptt2) ;/100.0)
            trPkTotal = totalEmp * exp(_kTran * ptt2) ;/100.0)
          endif
        endif

        ; midday transit
        lttop = 2*(MW[41]+MW[42]) + (MW[43]+MW[44])   ;2*OVT + IVT
        pttop = 2*(MW[61]+MW[62]) + (MW[63]+MW[64])   ;2*OVT + IVT
        
        ltt2op= MW[41]+MW[42]+MW[43]+MW[44]   ;OVT + IVT
        ptt2op= MW[61]+MW[62]+MW[63]+MW[64]   ;OVT + IVT
        
        if(lttop>0) 
         if(lttop<pttop)
            trOpRetail = retailEmp * exp(_kTran * ltt2op) ;/100.0)
            trOpTotal = totalEmp * exp(_kTran * ltt2op) ;/100.0)
         endif
        else
          if(pttop>0)
            trOpRetail = retailEmp * exp(_kTran * ptt2op) ;/100.0)
            trOpTotal = totalEmp * exp(_kTran * ptt2op) ;/100.0)
          endif
        endif

        ; walk
        nmDist = (mi.2.2[j] + mi.2.2.T[j]) ;/100.0
        if(nmDist<=(_maxNmDistance * 2)) 
          nmRetail = retailEmp * exp(_kWalk * nmDist)
          nmTotal = totalEmp * exp(_kWalk * nmDist)
        endif

     ; debug
     if(_debug==1 && i==_debugOrig && j==_debugDest)
     
        list = "Origin zone           = ",_debugOrig(15.2),file=accessibilityFile.debug
        list = "Destination zone      = ",_debugDest(15.2),file=accessibilityFile.debug
        list = "Retail/Service Emp    = ",retailEmp(15.2),file=accessibilityFile.debug
        list = "Total Emp             = ",totalEmp(15.2),file=accessibilityFile.debug
        list = " ",file=accessibilityFile.debug
        list = "Peak Auto time        = ",auPkTime(15.2),file=accessibilityFile.debug
        list = "Off-Peak Auto time    = ",auOpTime(15.2),file=accessibilityFile.debug
        list = "Peak Auto Retail accessibility  = ",auPkRetail(15.2),file=accessibilityFile.debug
        list = "Off-Peak Auto Retail accessibility  = ",auOpRetail(15.2),file=accessibilityFile.debug
        list = "Peak Auto Total accessibility  = ",auPkTotal(15.2),file=accessibilityFile.debug
        list = "Off-Peak Auto Total accessibility  = ",auOpTotal(15.2),file=accessibilityFile.debug
        list = "Peak Local Transit time     = ",ltt2(15.2),file=accessibilityFile.debug
        list = "Off-Peak Local Transit time     = ",ltt2op(15.2),file=accessibilityFile.debug
        list = "Peak Premium Transit time     = ",ptt2(15.2),file=accessibilityFile.debug
        list = "Off-Peak Premium Transit time     = ",ptt2op(15.2),file=accessibilityFile.debug
        list = "Peak Transit Retail accessibility = ",trPkRetail(15.2),file=accessibilityFile.debug
        list = "Off-Peak Transit Retail accessibility = ",trOpRetail(15.2),file=accessibilityFile.debug
        list = "Peak Transit Total accessibility = ",trPkTotal(15.2),file=accessibilityFile.debug
        list = "Off-Peak Transit Total accessibility = ",trOpTotal(15.2),file=accessibilityFile.debug
        list = "Non-motorized distance  = ",nmDist(15.2),file=accessibilityFile.debug
        list = "Non-motorized retail accessibility    = ",nmRetail(15.2),file=accessibilityFile.debug
        list = "Non-motorized total accessibility    = ",nmTotal(15.2),file=accessibilityFile.debug
     
     endif
     
     ; sum the utilities
     sumAuPkRetail = sumAuPkRetail + auPkRetail
     sumAuPkTotal  = sumAuPkTotal  + auPkTotal
     sumAuOpRetail = sumAuOpRetail + auOpRetail
     sumAuOpTotal  = sumAuOpTotal  + auOpTotal
     sumTrPkRetail = sumTrPkRetail + trPkRetail
     sumTrPkTotal  = sumTrPkTotal  + trPkTotal
     sumTrOpRetail = sumTrOpRetail + trOpRetail
     sumTrOpTotal  = sumTrOpTotal  + trOpTotal
     sumNmRetail   = sumNmRetail   + nmRetail
     sumNmTotal    = sumNmTotal    + nmTotal
   
   endjloop
   
   ; compute the logsums
   ;if(sumAuPkRetail>0.0) 
      lnAuPkRetail = ln(sumAuPkRetail + 1)
   ;else
   ;   lnAuPkRetail = 0.0
   ;endif
   
   ;if(sumAuPkTotal>0.0) 
      lnAuPkTotal = ln(sumAuPkTotal + 1)
   ;else
   ;   lnAuPkTotal = 0.0
   ;endif
   
   ;if(sumAuOpRetail>0.0) 
      lnAuOpRetail = ln(sumAuOpRetail + 1)
   ;else
   ;   lnAuOpRetail = 0.0
   ;endif
   
   ;if(sumAuOpTotal>0.0) 
      lnAuOpTotal = ln(sumAuOpTotal + 1)
   ;else
   ;   lnAuOpTotal = 0.0
   ;endif
   
   ;if(sumTrPkRetail>0.0) 
      lnTrPkRetail = ln(sumTrPkRetail + 1)
   ;else
   ;   lnTrPkRetail = 0.0
   ;endif
   
   ;if(sumTrPkTotal>0.0) 
      lnTrPkTotal = ln(sumTrPkTotal + 1)
   ;else
   ;   lnTrPkTotal = 0.0
   ;endif
   
   ;if(sumTrOpRetail>0.0) 
      lnTrOpRetail = ln(sumTrOpRetail + 1)
   ;else
   ;   lnTrOpRetail = 0.0
   ;endif
   
   ;if(sumTrOpTotal>0.0) 
      lnTrOpTotal = ln(sumTrOpTotal + 1)
   ;else
   ;   lnTrOpTotal = 0.0
   ;endif
   
   ;if(sumNmRetail>0.0) 
      lnNmRetail = ln(sumNmRetail + 1)
   ;else
   ;   lnNmRetail = 0.0
   ;endif
   
   ;if(sumNmTotal>0.0) 
      lnNmTotal = ln(sumNmTotal + 1)
   ;else
   ;   lnNmTotal = 0.0
   ;endif
   
   ; debug
   if(_debug==1 && i==_debugOrig)
     
      list = " ",file=accessibilityFile.debug
      list = "Sum of Auto Peak Retail    = ",sumAuPkRetail(15.2),file=accessibilityFile.debug
      list = "LogSum Auto Peak Retail    = ",lnAuPkRetail(15.2),file=accessibilityFile.debug
      list = "Sum of Auto Off-Peak Retail    = ",sumAuOpRetail(15.2),file=accessibilityFile.debug
      list = "LogSum Auto Off-Peak Retail    = ",lnAuOpRetail(15.2),file=accessibilityFile.debug
      list = "Sum of Auto Peak Total    = ",sumAuPkTotal(15.2),file=accessibilityFile.debug
      list = "LogSum Auto Peak Total    = ",lnAuPkTotal(15.2),file=accessibilityFile.debug
      list = "Sum of Auto Off-Peak Total    = ",sumAuOpTotal(15.2),file=accessibilityFile.debug
      list = "LogSum Auto Off-Peak Total    = ",lnAuOpTotal(15.2),file=accessibilityFile.debug
      list = "Sum of Transit Peak Retail    = ",sumTrPkRetail(15.2),file=accessibilityFile.debug
      list = "LogSum Transit Peak Retail    = ",lnTrPkRetail(15.2),file=accessibilityFile.debug
      list = "Sum of Transit Off-Peak Retail    = ",sumTrOpRetail(15.2),file=accessibilityFile.debug
      list = "LogSum Transit Off-Peak Retail    = ",lnTrOpRetail(15.2),file=accessibilityFile.debug
      list = "Sum of Transit Peak Total    = ",sumTrPkTotal(15.2),file=accessibilityFile.debug
      list = "LogSum Transit Peak Total    = ",lnTrPkTotal(15.2),file=accessibilityFile.debug
      list = "Sum of Transit Off-Peak Total    = ",sumTrOpTotal(15.2),file=accessibilityFile.debug
      list = "LogSum Transit Off-Peak Total    = ",lnTrOpTotal(15.2),file=accessibilityFile.debug
      list = "Sum of Non-motorized Retail   = ",sumNmRetail(15.2),file=accessibilityFile.debug
      list = "LogSum Non-motorized Retail  = ",lnNmRetail(15.2),file=accessibilityFile.debug
      list = "Sum of Non-motorized Total   = ",sumNmTotal(15.2),file=accessibilityFile.debug
      list = "LogSum Non-motorized Total  = ",lnNmTotal(15.2),file=accessibilityFile.debug
     
   endif

  IF  (I<={lastin})   ;only write out internal zones
   ; write out the data
   list = i(8.0),",",lnAuPkRetail(15.4),",",lnAuPkTotal(15.4),",",lnAuOpRetail(15.4),",",lnAuOpTotal(15.4), 
          ",",lnTrPkRetail(15.4),",",lnTrPkTotal(15.4),",",lnTrOpRetail(15.4),",",lnTrOpTotal(15.4), 
          ",",lnNmRetail(15.4),",",lnNmTotal(15.4),
          file=accessibility.csv
  ENDIF
   
ENDRUN