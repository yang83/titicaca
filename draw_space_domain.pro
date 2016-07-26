pro draw_space_domain, fA, fB, YRANGE=YRANGE, RESTORE_FILE, RASTER_FILENAME1=RASTER_FILENAME1, RASTER_FILENAME2=RASTER_FILENAME2, RASTER_WV1=RASTER_WV1, RASTER_WV2=RASTER_WV2, IM_XRANGE=IM_XRANGE, IM_YRANGE=IM_YRANGE, RASTER_TITLE1=RASTER_TITLE1, RASTER_TITLE2=RASTER_TITLE2

;	IM_XRANGE=[220, 270] & IM_YRANGE=[-250, -200]
;	YRANGE=[0, 2300]
;	restore, '20130818_sunspot01.sav'
;	n_chosenim=29
;	fA=findfile('sunspot/*A1.fts')
;	fB=findfile('sunspot/*B1.fts')
	restore, RESTORE_FILE

!P.FONT=-1
	x1=data.posx
	y1=data.posy
	raster_fileA=data.ref_file & raster_fileB=data.ref_file
	IF KEYWORD_SET(RASTER_FILENAME1) THEN raster_fileA=RASTER_FILENAME1
	IF KEYWORD_SET(RASTER_FILENAME2) THEN raster_fileB=RASTER_FILENAME2
	raster_wvA=0 & raster_wvB=0.
	if KEYWORD_SET(RASTER_WV1) THEN raster_wvA=RASTER_WV1
	IF KEYWORD_SET(RASTER_WV2) THEN raster_wvB=RASTER_WV2
	fiss2map, raster_fileA, raster_A1, wv=raster_wvA, FWHM=0.1, /ROTNSHIFT
	fiss2map, raster_fileB, raster_B1, wv=raster_wvB, FWHM=0.1, /ROTNSHIFT

	;IF N_PARAMS() eq 5 then begin
	;	readcol, POSITION_FILE, x1, y1
	;	n_chosenim=y1
	;ENDIF
	
	newpos=fiss_rotate_pixel_position(data.ref_file, x1, y1, data.ref_file, /ROTNSHIFT)
	x2=newpos[*, 0]
	y2=newpos[*, 1]
	
	line=pix2asc([[x2], [y2]], raster_A1)
	x=line[*, 0]&  y=line[*, 1]
	
	sizeofA=size(data.dataA, /DIMENSION)
	sizeofB=size(data.dataB, /DIMENSION)
	

	dataA=FLTARR(sizeofA)
	dataB=FLTARR(sizeofB)
	;mapA=!NULL & mapB=!NULL
	ttt=replicate(255, 1024, 768)
	tv, bytscl(ttt, 0, 255)
	start_pix=0
;	x=x[start_pix:70] & y=y[start_pix:70]
;	mk_bgprofile, data, refIA1, refIB1, /REFERENCE_FUNCTION, fA, fB
	window, xs=1024, ys=768
	
;for j=start_pix, sizeofA[2]-1 do begin
;		
;		refIA=total(data.dataA[*, *, j], 2)/(size(data.dataA, /DIMENSION))[1]
;		refIB=total(data.dataB[*, *, j], 2)/(size(data.dataA, /DIMENSION))[1]
;		refIA1=refIA#replicate(1., sizeofA[1])
;		refIB1=refIB#replicate(1., sizeofB[1])
;		dataA[*, *, j]=(data.dataA[*, *, j]-refIA1)/refIA1
;		dataB[*, *, j]=(data.dataB[*, *, j]-refIB1)/refIB1
;			
;	;	for k=0, n_elements(dataA[0, *, 0])-1 do IF dataA[0, k, j] ne 0 then	dataA[*, k, j]=dataA[*, k, j]/mean(dataA[0:50, *, j])
;	;	for k=0, n_elements(dataB[0, *, 0])-1 do IF dataB[0, k, j] ne 0 then dataB[*, k, j]=dataB[*, k, j]/mean(dataB[0:50, *, j])
;	
;endfor
	mk_bgprofile, data, refIA, refIB
	dataA=(data.dataA-refIA)/refIA & dataB=(data.dataB-refIB)/refIB

for k=0, n_elements(dataA[0, *, 0])-1 do begin


		IF NOT KEYWORD_SET(RASTER_FILENAME1) THEN fiss2map, fA[k], raster_A1, wv=raster_wvA, FWHM=0.25, /ROTNSHIFT
		IF NOT KEYWORD_SET(RASTER_FILENAME2) THEN fiss2map, fB[k], raster_B1, wv=raster_wvB, FWHM=0.25, /ROTNSHIFT


		shiftx=data.posx-shift(data.posx, 1) & shifty=data.posy-shift(data.posy, 1)
		dist1=sqrt(shiftx*shiftx+ shifty*shifty)
		dist1[0]=0.
		for i=1, n_elements(dist1)-1 do dist1[i]=dist1[i-1]+dist1[i]
		dist1=dist1*0.16
		
		;oplot, [0, x[j-start_pix]], [0, y[j-start_pix]], PSYM=8, COLOR=150
		mapA=wv_time_diagram(data.wvA, dist1, reform(dataA[*, k, *]), $
								TITLE='Ha Spectra Variation with Time', /SPACE)
		mapB=wv_time_diagram(data.wvB, dist1, reform(dataB[*, k, *]), $
								TITLE='Ca II Spectra Variation with Time', /SPACE)
		if NOT KEYWORD_SET(YRANGE) THEN YRANGE=[dist1[0], dist1[-1]]	
		sub_map, mapA, smapA, YRANGE=YRANGE, XRANGE=[-3, 3]
		sub_map, mapB, smapB, YRANGE=YRANGE, XRANGE=[-3, 3]	
	
		tv, bytscl(ttt, 0, 255)	

		;if k eq 0 then begin
			mA=median(smapA.data) & mB=median(smapB.data)
			sA=stddev(smapA.data) & sB=stddev(smapB.data)
			DRANGEA=[mA-4.*sA, mA+4.*sA]
			DRANGEB=[mB-4.*sB, mB+4.*sB]
		;endif

		LOADCT_ch, /ca
		plot_map, smapB, YRANGE=YRANGE, XRANGE=[-3, 3], POSITION=[0.70, 0.1, 0.93, 0.9], /NOERASE , TITLE='Ca II IR (8542'+STRING(197B)+')', COLOR=0, CHARSIZE=2, /NOYTITLE, YTITLE=''	, XTITLE='Wavelength ['+STRING(197B)+']', DRANGE=DRANGEB, CHARTHICK=2
                Loadct_ch, /ha
		plot_map, smapA, YRANGE=YRANGE, XRANGE=[-3, 3], POSITION=[0.45, 0.1, 0.68, 0.9], /NOERASE, TITLE='H'+greek('alpha')+' (6563'+STRING(197B)+')', COLOR=0, CHARSIZE=2, XTITLE='Wavelength ['+STRING(197B)+']', YTITLE='TIME [second]', DRANGE=DRANGEA, CHARTHICK=2
	

		szofa=size(raster_A1.data, /DIMENSION)
		testmapa=raster_A1.data[szofa[0]/2.-30:szofa[0]/2.+29,szofa[1]/2.-30:szofa[1]/2.+29]
		testmapb=raster_B1.data[szofa[0]/2.-30:szofa[0]/2.+29,szofa[1]/2.-30:szofa[1]/2.+29] 
		mA=median(testmapa) & mB=median(testmapb)
		sA=stddev(testmapa) & sB=stddev(testmapb)
		DRANGEA_raster=[mA-4*sA, mA+6.*sA]
		DRANGEB_raster=[mB-4*sB, mB+6.*sB]
		;print, DRANGEA_raster
		;print, DRANGEB_raster
		LOADCT_ch, /ha
		;LOADCT, 0, /SIL
		plot_map, raster_A1, POSITION=[0.08, 0.55, 0.33, 0.90], $
			/NOERASE, TITLE=RASTER_TITLE1, XTITLE='X [arcsecond]', YTITLE='Y [arcsecond]', COLOR=0, $
			DRANGE=DRANGEA_raster, /ISO, XRANGE=IM_XRANGE, YRANGE=IM_YRANGE
		oplot, x, y, COLOR=255, THICK=2, PSYM=3
		LOADCT, 3, /SIL
		LOADCT_ch, /ca
		;LOADCT, 0, /SIL
		plot_map, raster_B1, POSITION=[0.08, 0.10, 0.33, 0.45], $
			/NOERASE, TITLE=RASTER_TITLE2, XTITLE='X [arcsecond]', YTITLE='Y [arcsecond]', COLOR=0, $
			DRANGE=DRANGEB_raster, /ISO, XRANGE=IM_XRANGE, YRANGE=IM_YRANGE
		oplot, x, y, COLOR=255, THICK=2, PSYM=3
		LOADCT, 3, /SIL
		LOADCT, 0, /SIL
	
		;		stddevA=stddev(dataA)
;		meanA=mean(dataA)
;		stddevB=stddev(dataB)
;		meanB=mean(dataB)
;		minmaxA=[meanA-stddevA*10, meanA+stddevA*10]
;		minmaxB=[meanB-stddevB*10, meanB+stddevB*10]
;		tv, bytscl(congrid(reform(dataA[*, 100:150, j]), 500, 500), minmaxA[0], minmaxA[1]), 0
;		tv, bytscl(congrid(reform(dataB[*, 100:150, j]), 500, 500), minmaxB[0], minmaxB[1]), 1

		xyouts, 0.05, 0.01, STRTRIM(STRING(FIX(data.timeA[k]-data.timeA[0])), 1)+'s', /NORMAL, CHARSIZE=3, COLOR=0
		name=(STRSPLIT(RESTORE_FILE, '.', /EXTRACT))[0]
	write_png, name+string(k, format='(I03)')+'_spacedomain.png', tvrd(/TRUE)

        print, STRING(ROUND(k))+ ' / ' + STRING(ROUND(n_elements(dataA[0, *, 0]))) 
	;write_png, strtrim(string(sizeofA[2]-1-j), 1)+'surge.png', tvrd(/TRUE)
	endfor
;j=55

end
