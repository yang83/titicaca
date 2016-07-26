
FUNCTION fiss_rotate_pixel_position, FILENAME, POS_X, POS_Y, REFERENCE_FILE, ROTNSHIFT=ROTNSHIFT, MAGNIFY=MAGNIFY
        ;POS_X, POS_Y : pixel information in image in reference file.	

	IF N_PARAMS() eq 4 THEN ref_file=REFERENCE_FILE ELSE ref_file=file_search(file_dirname(FILENAME), FXPAR(headfits(FILENAME), 'ALGN_REF'))
        IF NOT KEYWORD_SET(MAGNIFY) THEN MAGNIFY=1
	IF N_ELEMENTS(POS_Y) NE N_ELEMENTS(POS_X) THEN BEGIN
		PRINT, "Num. of POS_X and Num. of POS_Y is different."
		RETURN, 0
	ENDIF



;============================================
	hr=headfits(ref_file)
	XPOS_REF		=FLOAT(FXPAR(hr, 'TEL_XPOS'))/0.16
	YPOS_REF		=FLOAT(FXPAR(hr, 'TEL_YPOS'))/0.16
	ROT_ANGLE_REF	=FLOAT(FXPAR(hr, 'ROTANGLE'))
	REF_CENTER		=[FLOAT(FXPAR(hr, 'NAXIS2')), FLOAT(FXPAR(hr, 'NAXIS3'))]/2.

	h=headfits(FILENAME)
	XPOS		=FLOAT(FXPAR(h, 'TEL_XPOS'))/0.16
	YPOS		=FLOAT(FXPAR(h, 'TEL_YPOS'))/0.16
	ROT_ANGLE	=FLOAT(FXPAR(h, 'ROTANGLE'))
	F_CENTER	=[FLOAT(FXPAR(h, 'NAXIS2')), FLOAT(FXPAR(h, 'NAXIS3'))]/2.


        
	ROT_PIX, POS_X, POS_Y, $
            ROT_ANGLE_REF, POS_Xt1, POS_Yt1, CENTER=REF_CENTER
	POS_Xt4=POS_Xt1+XPOS_REF
	POS_Yt4=POS_Yt1+YPOS_REF
        
        POS_Xt5=POS_Xt4-XPOS
	POS_Yt5=POS_Yt4-YPOS
	
        ROT_PIX, POS_Xt5, POS_Yt5, -ROT_ANGLE, POS_Xt6, POS_Yt6, $
					CENTER=F_CENTER
;stop
	RETURN, [[POS_Xt6], [POS_Yt6]]		
END

