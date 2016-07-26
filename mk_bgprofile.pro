pro mk_bgprofile, data, refIA_return, refIB_return, REFERENCE_FUNCTION=REFERENCE_FUNCTION, fA, fB


	sizeofA=size(data.dataA, /DIMENSION)
	sizeofB=size(data.dataB, /DIMENSION)
	
	dataA=data.dataA
	dataB=data.dataB
	refIA_return=FLTARR(sizeofA)
;	refIA_return_median=FLTARR(sizeofA)
	refIB_return=FLTARR(sizeofB)
	refIA=FLTARR(sizeofA[0])
	refIB=FLTARR(sizeofB[0])
;	refIA_median=FLTARR(sizeofA[0])



	for j=0, sizeofA[2]-1 do begin
		for k=0, sizeofA[1]-1 do begin
			data.dataA[*, k, j]=data.dataA[*, k, j]/(mean([data.dataA[0:49, k, j], data.dataA[462:511, k, j]])>0.1)*0.85
			data.dataB[*, k, j]=data.dataB[*, k, j]/(mean([data.dataB[0:49, k, j], data.dataB[452:501, k, j]])>0.1)*0.80
		endfor
	endfor

	data.dataA[data.dataA gt 10000.]=0.
	data.dataB[data.dataB gt 10000.]=0.
	data.dataA[data.dataA lt -10000.]=0.
	data.dataB[data.dataB lt -10000.]=0.

	for j=0, sizeofA[2]-1 do begin
		for wv=0, sizeofA[0]-1 do begin
			temp=reform(data.dataA[wv, *,  j])
			if (where(temp gt 0.01))[0] ne -1 then refIA[wv]=median(temp[where(temp gt 0.01)])

		endfor

		for wv=0, sizeofB[0]-1 do begin
			temp=reform(data.dataB[wv, *, j])
			if (where(temp gt 0.01))[0] ne -1 then refIB[wv]=median(temp[where(temp gt 0.01)])
		endfor

	endfor
;==============================================================================================
;==================================REFERENCE2013 PROFILE=======================================
;==============================================================================================
	IF KEYWORD_SET(REFERENCE_FUNCTION) THEN BEGIN
		;fA=findfile('../20130816/sunspot1_02/*A1rss*.fts')
		;fB=findfile('../20130816/sunspot1_02/*B1rss*.fts')
		fA1=data.fA[0]
		fB1=data.fB[0]
		imA=fiss_readfits_heesu(fA1, wlha, hha, /NO_WVCALIB)
		imB=fiss_readfits_heesu(fB1, wlca, hca, /NO_WVCALIB)

		refIA_new=reference2013(refIA, imA, wlha, [-2, 2], [-4, 4], 1000.)
		refIB_new=reference2013(refIB, imB, wlca, [-2, 2], [-4, 4], 1000.)

		refIA=refIA_new
		refIB=refIB_new
	ENDIF
;==============================================================================================


	FOR j=0, sizeofA[2]-1 do begin

		;refIA=total(data.dataA[*, *, j], 2)/sizeofA[1]
		;refIB=total(data.dataB[*, *, j], 2)/sizeofB[1]
		refIA_return[*, *, j]=refIA#replicate(1., sizeofA[1])
		refIB_return[*, *, j]=refIB#replicate(1., sizeofB[1])
;		refIA_return_median[*, *, j]=refIA_median#replicate(1., sizeofA[1])

	ENDFOR
;	IF not KEYWORD_SET(REFERENCE_FUNCTION) THEN return
		;reference2013(refIA, 

	

;	stop

;save, FILENAME='bgprofile.sav', refIA_return, refIB_return

end



