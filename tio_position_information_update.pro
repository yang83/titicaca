pro tio_position_information_update, FILENAME, ROTATION_ANGLE, X_OFFSET, Y_OFFSET, REF_IMAGE, TEL_XPOS, TEL_YPOS, CDELT1, CDELT2
        IF NOT KEYWORD_SET(CDELT1) THEN CDELT1=0.0341796875000
        IF NOT KEYWORD_SET(CDELT2) THEN CDELT2=0.0341796875000
        IF NOT KEYWORD_SET(REF_IMAGE) THEN REF_IMAGE=FILENAME[0]      
        FOR i=0, N_ELEMENTS(FILENAME)-1 DO BEGIN
            h=HEADFITS(FILENAME[i])
            fxaddpar, h, 'CDELT1', CDELT1, 'image scale arcsec/pixel. tio align by H.Yang', BEFORE='HISTORY'
            fxaddpar, h, 'CDELT2', CDELT2, 'image scale arcsec/pixel. tio align by H.Yang', BEFORE='HISTORY'
            ;print, X_OFFSET[i], Y_OFFSET[i], TEL_XPOS, TEL_YPOS
            fxaddpar, h, 'TEL_XPOS', TEL_XPOS+X_OFFSET[i]*CDELT1, 'tio align by H.Yang', BEFORE='HISTORY'
            fxaddpar, h, 'TEL_YPOS', TEL_YPOS+Y_OFFSET[i]*CDELT2, 'tio align by H.Yang', BEFORE='HISTORY'
            fxaddpar, h, 'ALGN_REF', FILE_BASENAME(REF_IMAGE),  'tio align by H.Yang', BEFORE='HISTORY'

            fxaddpar, h, 'ROTANGLE', ROTATION_ANGLE[i],  'tio align by H.Yang', BEFORE='HISTORY'

            caldat, systime(/JULIAN), MON, DAY, YEAR, HOUR, MIN, SEC
            TIMESTR=STRING(YEAR, MON, DAY, FORMAT='(I04, I02, I02)')+'_'+STRING(HOUR, MIN, SEC, FORMAT='(I02, I02, I02)')
            fxaddpar, h, 'HISTORY', 'Header Information updated by Heesu Yang at     '+TIMESTR
            modfits, FILENAME[i], 0, h
        ENDFOR
END

