pro fiss_position_information_update, FILENAME, ROTATION_ANGLE, X_OFFSET, Y_OFFSET, REF_IMAGE, TEL_XPOS, TEL_YPOS, CDELT2, CDELT3

        IF NOT KEYWORD_SET(CDELT2) THEN CDELT2=0.16
        IF NOT KEYWORD_SET(CDELT3) THEN CDELT3=0.16
	For i=0, N_ELEMENTS(FILENAME)-1 DO BEGIN
		h=headfits(FILENAME[i])
		fxaddpar, h, 'ALGN_REF', FILE_BASENAME(REF_IMAGE), 'FISS align code by Heesu Yang', BEFORE='HISTORY'
		fxaddpar, h, 'TEL_XPOS', TEL_XPOS+X_OFFSET[i]*CDELT2, 'FISS align code by Heesu Yang', BEFORE='HISTORY'
		fxaddpar, h, 'TEL_YPOS', TEL_YPOS+Y_OFFSET[i]*CDELT3,'FISS align code by Heesu Yang', BEFORE='HISTORY'
		fxaddpar, h, 'ROTANGLE', ROTATION_ANGLE[i],'FISS align code by Heesu Yang', BEFORE='HISTORY'
                IF KEYWORD_SET(CDELT2) THEN BEGIN
                fxaddpar, h, 'CDELT2', CDELT2, 'image scale arcsec/pixel'
                fxaddpar, h, 'CDELT3', CDELT3, 'image scale arcsec/pixel'
                ENDIF
		caldat, systime(/JULIAN), MON, DAY, YEAR, HOUR, MIN, SEC
		TIMESTR=STRING(YEAR, MON, DAY, FORMAT='(I04, I02, I02)')+'_'+STRING(HOUR, MIN, SEC, FORMAT='(I02, I02, I02)')
		fxaddpar, h, 'HISTORY', 'Header Information updated by Heesu Yang at '+TIMESTR
		modfits, FILENAME[i], 0, h
		
	ENDFOR
end
