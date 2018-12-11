pro niris2map, filename,  map, PARAMETER=PARAMETER, xc=xc, yc=yc, dx=dx, dy=dy, ROTNSHIFT=ROTNSHIFT;, CALIBRATION_DATA=CALIBRATION_DATA
	
;wv : wavelength of you want.
;xc : Image center in arcsec
;yc : Image center in arcsec

;Oct 3 2013, Heesu Yang : FWHM keyword added.
;Jul 14 2014, Heesu Yang : SQUARE keyword added. & title modified
;Jan 14 2015, Heesu Yang : keyword_removed in 'fiss_readfits_heesu' function
;Jan 14 2015, Heesu Yang : wv=0 if wv is not set.
;Jan 15 2015, Heesu Yang : add function make_fissmap to output maparr
;Jan 15 2015, Heesu Yang : ENLARGE keyword added.
;Jul 27 2016, Heesu Yang : function changed from 'fiss_readfits_heesu' to fiss_readfits_y'
;Nov 2 2017, H. Yang : copied from fiss2map
        
        CASE STRLOWCASE(PARAMETER) OF
                'sp'            : spectromap_on=1
                'b_total'       : frame=0
                'theta'         : frame=1
                'chi'           : frame=2
                'eta0'          : frame=3
                'dlambdad'      : frame=4
                'a'             : frame=5
                'lambda0'       : frame=6
                's0'            : frame=7
                's1'            : frame=8
                'intensity'     : frame=9
        ELSE : print, 'parameter error'
        ENDCASE

        
        IF KEYWORD_SET(spectromap_on) THEN BEGIN
                h=headfits(filename)
                inc=fxpar(h, 'CDELT1')
                startwv=fxpar(h, 'STARTWV')
                n_pixwv=fxpar(h, 'NAXIS1')
                wv=inc*FINDGEN(n_pixwv)+startwv
                x=where(abs(wv) eq min(abs(wv)))
                im3d=readfits(filename, h)
                im=reform(im3d[x[0], *, *])
         ENDIF ELSE BEGIN
                im=readfits(filename, h)
         ENDELSE
	       

        m_time  =fxpar(h, 'DATE')
        x_pixelscale=fxpar(h, 'CDELT2')
        y_pixelscale=fxpar(h, 'CDELT3')
        IF x_pixelscale eq 0. then x_pixelscale=0.16
        IF y_pixelscale eq 0. then y_pixelscale=0.16
	m_title ='NIRIS '+ STRUPCASE(PARAMETER) +m_time
	if not keyword_set(xc) then xc=fxpar(h, 'TEL_XPOS')
	if not keyword_set(yc) then yc=fxpar(h, 'TEL_YPOS')
	if not keyword_set(dx) then dx=x_pixelscale
	if not keyword_set(dy) then dy=y_pixelscale
	if not keyword_set(wavelength) then wavelength=0.
        
        IF NOT KEYWORD_SET(SPECTROMAP_ON) THEN BEGIN
                IF KEYWORD_SET(ROTNSHIFT) THEN BEGIN
                    sz=size(im)
                    imx=MAKE_ARRAY(sz[2]*1.2, sz[3]*1.2, TYPE=sz[4], VALUE=MEDIAN(im[frame, *, *]))
                    imx[sz[2]*0.1:sz[2]*1.1-1, sz[3]*0.1:sz[3]*1.1-1]=reform(im[frame, *, *])
                    angle=0.
                    angle=fxpar(h, 'ROTANGLE')
                   imx=rot(imx, angle)
                ENDIF ELSE BEGIN
                    imx=im
                ENDELSE
                map=make_map(imx, xc=xc, yc=yc, dx=dx, dy=dy, TITLE=m_title, TIME=m_time)
        ENDIF ELSE BEGIN
                IF KEYWORD_SET(ROTNSHIFT) THEN BEGIN
                    sz=size(im3d)
                    im3dx=MAKE_ARRAY(sz[1], sz[2]*1.2, sz[3]*1.2, TYPE=sz[4], VALUE=MEDIAN(im))
                    FOR i=0, sz[1]-1 DO im3dx[i, sz[2]*0.1:sz[2]*1.1-1, sz[3]*0.1:sz[3]*1.1-1]=reform(im3d[i, *, *])
                    angle=0.
                    angle=fxpar(h, 'ROTANGLE')
                    im3dx=fiss_rot(im3dx, angle)
                ENDIF ELSE BEGIN
                    im3dx=im3d
                ENDELSE
                map={data:reform(im3dx[x[0], *, *]), $
                    data3d:im3dx, wv:wv, $
                    xc:xc, yc:yc, dx:dx, dy:dy, $
                    TITLE:m_title, TIME:m_time, ID:'', $
                    DUR:0.0, XUNITS:'arcsecs', YUNITS:'arcsecs'}
            ENDELSE 

        return
end
