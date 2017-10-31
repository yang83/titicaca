pro tio2map, filename,  map, xc=xc, yc=yc, dx=dx, dy=dy, ROTNSHIFT=ROTNSHIFT, ANGLE=ANGLE
	
;wv : wavelength of you want.
;xc : Image center in arcsec
;yc : Image center in arcsec

;Oct 27 2017 H. Yang : copied from fiss2map

	im=readfits(filename, h)
        
        m_time  =fxpar(h, 'DATE-OBS')+' '+fxpar(h, 'TIME-OBS')
        x_pixelscale=fxpar(h, 'CDELT1')
        y_pixelscale=fxpar(h, 'CDELT2')
        IF x_pixelscale eq 0. then x_pixelscale= 0.0341796875000
        IF y_pixelscale eq 0. then y_pixelscale= 0.0341796875000
	m_title ='TiO '+ m_time
	if not keyword_set(xc) then xc=fxpar(h, 'TEL_XPOS')
	if not keyword_set(yc) then yc=fxpar(h, 'TEL_YPOS')
	if not keyword_set(dx) then dx=x_pixelscale
	if not keyword_set(dy) then dy=y_pixelscale
        

        IF KEYWORD_SET(ROTNSHIFT) THEN m_angle=fxpar(h, 'ROTANGLE') else m_angle=0
        IF KEYWORD_SET(ANGLE) THEN m_angle=ANGLE

        IF KEYWORD_SET(ROTNSHIFT) or KEYWORD_SET(ANGLE) THEN BEGIN
                sz=size(im)        
                imx= MAKE_ARRAY(sz[1]*1.2, sz[2]*1.2, TYPE=sz[3], VALUE=MEDIAN(im))
                xszx=sz[1]*0.2
                imx[sz[1]*0.1:sz[1]*1.1-1, sz[2]*0.1:sz[2]*1.1-1]=im
                map= make_map(ROT(imx, m_angle), DX=DX, DY=DY, XC=XC, YC=YC, TITLE=M_TITLE, TIME=m_TIME)       
        ENDIF ELSE BEGIN
                map= make_map(ROT(im, m_angle), DX=DX, DY=DY, XC=XC, YC=YC, TITLE=M_TITLE, TIME=m_TIME)       
        ENDELSE
        end
