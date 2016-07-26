FUNCTION fiss_rotate_read_pixel, FILENAME, POS_X, POS_Y, REFERENCE_FILE=REFERENCE_FILE, SAVE_PNG=SAVE_PNG, INTERPOLATE=INTERPOLATE



;H. YANG 2015 Jan 19 INTERPOLATE keyword added.

	IF NOT KEYWORD_SET(REFERENCE_FILE) THEN ref_file=FILENAME[0] ELSE ref_file=REFERENCE_FILE

	ref_im=readfits(ref_file)
	 
	RVALUE=	FLTARR(fxpar(headfits(FILENAME[0]), 'NAXIS1'), N_ELEMENTS(FILENAME), N_ELEMENTS(POS_X))
	FOR i=0, N_ELEMENTS(FILENAME)-1 DO BEGIN
		imA=readfits(FILENAME[i], h)
		sizeof_sample_im=(SIZE(imA, /DIMENSION))[1:2]
		ret_pos=fiss_rotate_pixel_position(FILENAME[i], POS_X, POS_Y, REFERENCE_FILE)
		RET_POS_X=ret_pos[*, 0]
		RET_POS_Y=ret_pos[*, 1]


		FOR j=0, N_ELEMENTS(POS_X)-1 DO $
			IF (fix(RET_POS_X[j]+1) LT N_ELEMENTS(reform(imA[0, *, 0]))) and (RET_POS_X[j] GE 0.) and $
		   		(fix(RET_POS_Y[j]+1) LT N_ELEMENTS(reform(imA[0, 0, *]))) and (RET_POS_Y[j] GE 0.) THEN $
					IF KEYWORD_SET(INTERPOLATE) THEN $
                                            FOR p=0, n_elements(imA[*, 0, 0])-1 do RVALUE[p, i, j] = interpolate(REFORM(imA[p, *, *]), RET_POS_X[j], RET_POS_Y[j]) $  ;interpolate(REFORM(imA[p, fix(RET_POS_X[j]):fix(RET_POS_X[j])+1, fix(RET_POS_Y[j]):fix(RET_POS_Y[j])+1]), RET_POS_X[j]-fix(RET_POS_X[j]), RET_POS_Y[j]-fix(RET_POS_Y[j])) $
                                        ELSE RVALUE[*, i, j]	=	imA[*, RET_POS_X[j], RET_POS_Y[j]]
                                                                       

;===================================
	;SAVE_PNG
;===================================
		IF KEYWORD_SET(SAVE_PNG) THEN BEGIN
			LOADCT, 0, /SIL
			t1=make_map(reform(imA[200, *, *]), XC=sizeof_sample_im[0]/2., YC=sizeof_sample_im[1]/2.)
			;r1=t1
			;r1.data=reform(ref_im[200, *,  *])
			;X_SHIFT=FLOAT(FXPAR(h, 'YSHIFT_X'))
			;Y_SHIFT=FLOAT(FXPAR(h, 'YSHIFT_Y'))
			;ROT_ANGLE=FLOAT(FXPAR(h, 'YROTANG'))
			;t1.data=rot(t1.data, ROT_ANGLE)
			;t1.data=shift(t1.data, X_SHIFT, Y_SHIFT)
			plot_map, t1, XRANGE=[0, sizeof_sample_im[0]], YRANGE=[0, sizeof_sample_im[1]]
			loadct, 33, /SIL
			oplot, RET_POS_X, RET_POS_Y, PSYM=3, COLOR=150, SYMSIZE=1, THICK=1
			oplot, POS_X, POS_Y, PSYM=3, COLOR=100, SYMSIZE=1, THICK=1
	write_png, FILENAME[i]+'test.png', TVRD(/TRUE)
		ENDIF
	
		
	ENDFOR
		
	RETURN,RVALUE
END

