function most_nearest_wv, wlha, wvs
	res=!NULL
	for i=0, n_elements(wvs)-1 do $
		res=[res, where(abs(wlha-wvs[i]) eq min(abs(wlha-wvs[i])))]
	return, res
end


pro mkpng_afterobs, fiss_filename_arrayA, fiss_filename_arrayB, SIGMA=SIGMA, NO_WVCALIB=NO_WVCALIB, WAVELENGTH_HA=WAVELENGTH_HA, WAVELENGTH_CA=WAVELENGTH_CA
;for fiss check image, rotating 90 deg for best display
device, retain=2
fA=fiss_filename_arrayA
fB=fiss_find_co_observed_bfile(fA, fiss_filename_arrayB)
;if not keyword_set(ZOOMIN) then zoomin=1
if keyword_set(FOV) then m_FOV=1 else m_FOV=0
if not keyword_set(SIGMA) then sigma=4.
if n_elements(SIGMA) ne 16 then SIGMA=replicate(sigma, 16)
IF NOT KEYWORD_SET(MAGNIFY) THEN MAGNIFY=1
IF NOT KEYWORD_SET(WAVELENGTH_HA) THEN WAVELENGTH_HA=[-4, -0.8, 0, 0.8]
IF NOT KEYWORD_SET(WAVELENGTH_CA) THEN WAVELENGTH_CA=[-4, -0.2, 0, 0.2]
imA=fiss_readfits_y(fA[0], wlha, hha, /NO_WVCALIB)
imB=fiss_readfits_y(fB[0], wlca, hca, /NO_WVCALIB)
;imAt=fiss_readfits_heesu(fA[0], wlhat, hhat, /NO_WVCALIB)
;imBt=fiss_readfits_heesu(fB[0], wlcat, hcat, /NO_WVCALIB)

sAt=size(imA, /DIMENSION)
sBt=size(imB, /DIMENSION)
sAi=sAt
sA=sAt[1:2]
if m_FOV eq 0 then FOV=[0,0, sBt[1]-1, sBt[2]-1]
pos=most_nearest_wv(wlha, WAVELENGTH_HA)
fA_im=imA[pos, FOV[0]:FOV[2], FOV[1]:FOV[3]]

;=========================================================================
;--------wv calibration------------------
;=========================================================================
IF NOT KEYWORD_SET(NO_WVCALIB) THEN BEGIN
        fiss_wv_calib, '6562', total(total(imA, 3), 2), wvpar1, method=0
	wlha=(findgen(512)-wvpar1[0])*wvpar1[1]+wvpar1[2]-6562.817d0
	fiss_wv_calib, '8542', total(total(imB, 3), 2), wvpar1, method=0
	wlca=(findgen(502)-wvpar1[0])*wvpar1[1]+wvpar1[2]-8542.09d0
ENDIF
;sA[1:2]=shift(sA[1:2], 1)

!P.FONT=1
window, 1

;scrollwindow, wid=1, ys=(FOV[2]-FOV[0]+1)*2, xs=(FOV[3]-FOV[1]+1)*4	
;scrollwindow, xs=512*4, ys=512*2
for i=0, n_elements(fA)-1 do begin
                      imA_norot=fiss_readfits_y(fA[i], wlhat, hhat, /no_wvcalib)
                hha=hhat
                sAt=size(imA, /DIMENSION)
                fiss2map, fA[i], fa_map, WV=WAVELENGTH_HA, /NO_WVCALIB, ROTNSHIFT=ROTNSHIFT
                if fB[i] ne ' ' then begin
                        fiss2map, fB[i], fb_map, WV=WAVELENGTH_CA, /NO_WVCALIB, ROTNSHIFT=ROTNSHIFT
                        
                        imB_norot=fiss_readfits_y(fB[i], wlcat, hcat, /no_wvcalib)
                        sBt=size(imB, /DIMENSION)
                endif else begin
			sBt=[sAt[0], 256, sAt[2]]
			imB=FLTARR(sBt)
		endelse
		if m_FOV eq 0 then FOV=[0,0, sBt[1]-1, sBt[2]-1]
	        pos=most_nearest_wv(wlha, WAVELENGTH_HA)
	        fa_im_norot=imA_norot[pos, *, *]	
		pos=most_nearest_wv(wlca, WAVELENGTH_CA)
		fb_im_norot=imB_norot[pos, *, *]
	
                window, xs=(FOV[3]-FOV[1]+1)*4, ys=(FOV[2]-FOV[0]+1)*2


		sA=size(fA_im, /DIMENSION)
		sB=size(fB_im, /DIMENSION)
;		wdelete, 1
		meanimA=FLTARR(4) & meanimB=FLTARR(4)
		stddevimA=FLTARR(4) & stddevimB=FLTARR(4)
                dr_a=FLTARR(4, 2) & dr_b=FLTARR(4, 2)
		for k=0, 3 do begin
                        fa_im_temp_norot             =reform(fA_im_norot[k, *, *])
                        fb_im_temp_norot             =reform(fB_im_norot[k, *, *])
			meanimA[k]		=median	(fA_im_temp_norot[where(fA_im_temp_norot ne 0.)])
			stddevimA[k]	=stddev	(fA_im_temp_norot[where(fA_im_temp_norot ne 0.)])
			if total(fB_im_temp_norot) ne 0. then meanimB[k]		=median	(fB_im_temp_norot[where(fB_im_temp_norot ne 0.)])
			if total(fB_im_temp_norot) ne 0. then stddevimB[k]	=stddev	(fB_im_temp_norot[where(fB_im_temp_norot ne 0.)])
		
			dr_a[k, *]=[meanimA[k]-sigma[k*2]*stddevimA[k], meanimA[k]+sigma[k*2+1]*stddevimA[k]]
			dr_b[k, *]=[meanimB[k]-sigma[8+k*2]*stddevimB[k], meanimB[k]+sigma[8+k*2+1]*stddevimB[k]]
		endfor
		sAz=sA
		sBz=sB
;	loadct, 3
        IF i eq 0 THEN CENTER=[fa_map[0].xc, fa_map[0].yc]
	loadct_ch, /ha
        FOR p=0, 3 DO $
        tv, BYTSCL(rotate(fa_map[p].data, 1), dr_a[p, 0], dr_a[p, 1]), (FOV[3]-FOV[1]+1)*p, (FOV[2]-FOV[0]+1)

        
        ;	loadct, 8
	loadct_ch, /ca

        FOR p=0, 3 DO $
        tv, BYTSCL(rotate(fb_map[p].data, 1), dr_b[p, 0], dr_b[p, 1]), (FOV[3]-FOV[1]+1)*p,0


	draw_clock, sAz[2]*2, sAz[1], fxpar(hha, 'DATE'), COLOR=255, CLOCKSIZE=30

	xyouts, 20, 		 sAz[1]+20, STRTRIM(STRING(WAVELENGTH_HA[0], FORMAT='(F4.1)'), 1)+STRING(197B), /DEVICE, COLOR=255, SIZE=2
	xyouts, sAz[2]*1+20, sAz[1]+20,  STRTRIM(STRING(WAVELENGTH_HA[1], FORMAT='(F4.1)'), 1)+STRING(197B), /DEVICE, COLOR=255, SIZE=2
	xyouts, sAz[2]*2+20, sAz[1]+20, 'H alpha', /DEVICE,  COLOR=255, SIZE=2
	xyouts, sAz[2]*3+20, sAz[1]+20,  STRTRIM(STRING(WAVELENGTH_HA[3],  FORMAT='(F4.1)'), 1)+STRING(197B), /DEVICE,  COLOR=255, SIZE=2
	xyouts, 20, 20,  STRTRIM(STRING(WAVELENGTH_CA[0],  FORMAT='(F4.1)'), 1)+STRING(197B), /DEVICE,  COLOR=255, SIZE=2
	xyouts, sAz[2]*1+20, 20, STRTRIM(STRING(WAVELENGTH_CA[1],  FORMAT='(F4.1)'), 1)+STRING(197B), /DEVICE,  COLOR=255, SIZE=2
	xyouts, sAz[2]*2+20, 20, 'Ca II IR', /DEVICE,  COLOR=255, SIZE=2
	xyouts, sAz[2]*3+20, 20,  STRTRIM(STRING(WAVELENGTH_CA[3],  FORMAT='(F4.1)'), 1)+STRING(197B), /DEVICE,   COLOR=255, SIZE=2
        xyouts, 20, 		 sAz[1]-20, fxpar(hha, 'DATE'), /DEVICE, COLOR=255, SIZE=2
	
        write_png, fA[i]+'_t.png', tvrd(/TRUE)
endfor

end
