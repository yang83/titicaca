function collect_spectra, fA, fB, x, y, INTERPOLATE=INTERPOLATE, PIXEL=PIXEL, ref_file=ref_file
;2015 Jan 19 (H.Yang) interpolate keyword_added.

                print, '**Warning**, Code changed. x, y coordinate should be provided in arcsec. For previous code, PIXEL keyword cna be used.'
                IF KEYWORD_SET(PIXEL) THEN BEGIN
                        dataA=fiss_rotate_read_pixel(fA, x, y, /SAVE_PNG, INTERPOLATE=INTERPOLATE, REFERENCE_FILE=ref_file)
		        dataB=fiss_rotate_read_pixel(fB, x, y, /SAVE_PNG, INTERPOLATE=INTERPOLATE, REFERENCE_FILE=ref_file)
                ENDIF ELSE BEGIN
                        dataA=fiss_rotate_read_arcsec(fA, x, y, INTERPOLATE=INTERPOLATE)
        		dataB=fiss_rotate_read_arcsec(fB, x, y, INTERPOLATE=INTERPOLATE)
                        ref_file='ascsec alignment'
                ENDELSE

		timeA=fltarr(n_elements(fa))
		ta=!NULL
		;for i=0, n_elements(fa)-1 do timeA[i]=mkdatetoftime(fxpar(headfits(fA[i]), 'DATE'))
		for i=0, n_elements(fA)-1 do ta=[ta, fxpar(headfits(fA[i]), 'DATE')]
		timeA=	mkdatetoftime(ta)
		timeB=fltarr(n_elements(fB))
		for i=0, n_elements(fB)-1 do timeB[i]=mkdatetoftime(fxpar(headfits(fB[i]), 'DATE'))
		imA=fiss_readfits_heesu(fA[0], wlha, hha, /NO_WVCALIB)
		imB=fiss_readfits_heesu(fB[0], wlca, hca, /NO_WVCALIB)
		fiss_wv_calib, '6562', total(total(imA, 3), 2), wvpar1, method=0
		wlha=(findgen(512)-wvpar1[0])*wvpar1[1]+wvpar1[2]-6562.817d0
		fiss_wv_calib, '8542', total(total(imB, 3), 2), wvpar1, method=0
		wlca=(findgen(502)-wvpar1[0])*wvpar1[1]+wvpar1[2]-8542.09d0


                shiftx=x-shift(x, 1) & shifty=y-shift(y, 1)
                dist1=sqrt(shiftx*shiftx+shifty*shifty)
                for i=1, n_elements(dist1)-1 do dist1[i]=dist1[i-1]+dist1[i]
                dist1=dist1*0.16

		data={dataA:dataA, dataB:dataB, timeA:timeA, timeB:timeB, wvA:wlha, wvB:wlca,$
				fA:fA, fB:fB, posx:x, posy:y, ref_File:ref_file, dist1:dist1, ref_time:timeA[0]}

                return, data
end
