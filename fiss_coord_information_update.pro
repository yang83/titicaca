pro fiss_coord_information_update, FILENAME, ROTANGLE=ROTANGLE, TEL_XPOS=TEL_XPOS, TEL_YPOS=TEL_YPOS, ALGN_REF=ALGN_REF, CDELT1=CDELT1, CDELT2=CDELT2, CDELT3=CDELT3

        IF KEYWORD_SET(CDELT1) THEN IF N_ELEMENTS(CDELT1) eq 1 THEN CDELT1=REPLICATE(1., N_ELEMENTS(FILENAME))*CDELT1


	For i=0, N_ELEMENTS(FILENAME)-1 DO BEGIN
		h=headfits(FILENAME[i])
		IF KEYWORD_SET(ALGN_REF) THEN fxaddpar, h, 'ALGN_REF', FILE_BASENAME(ALGN_REF[i]), 'FISS align code by Heesu Yang', BEFORE='HISTORY'
		IF KEYWORD_SET(TEL_XPOS) THEN fxaddpar, h, 'TEL_XPOS', TEL_XPOS[i], 'FISS align code by Heesu Yang', BEFORE='HISTORY'
		IF KEYWORD_SET(TEL_YPOS) THEN fxaddpar, h, 'TEL_YPOS', TEL_YPOS[i],'FISS align code by Heesu Yang', BEFORE='HISTORY'
		IF KEYWORD_SET(ROTANGLE) THEN fxaddpar, h, 'ROTANGLE', ROTANGLE[i],'FISS align code by Heesu Yang', BEFORE='HISTORY'
                IF KEYWORD_SET(CDELT1) THEN fxaddpar, h, 'CDELT1', CDELT1[i], 'image scale arcsec/pixel'
                IF KEYWORD_SET(CDELT2) THEN fxaddpar, h, 'CDELT2', CDELT2[i], 'image scale arcsec/pixel'
                IF KEYWORD_SET(CDELT3) THEN fxaddpar, h, 'CDELT3', CDELT3[i], 'image scale arcsec/pixel'
 
	caldat, systime(/JULIAN), MON, DAY, YEAR, HOUR, MIN, SEC
		TIMESTR=STRING(YEAR, MON, DAY, FORMAT='(I04, I02, I02)')+'_'+STRING(HOUR, MIN, SEC, FORMAT='(I02, I02, I02)')
		fxaddpar, h, 'HISTORY', 'Header Information updated by Heesu Yang at '+TIMESTR
		modfits, FILENAME[i], 0, h
		
	ENDFOR
end
