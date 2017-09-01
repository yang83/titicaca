function make_fissmap, im, wlha, hHa, SQUARE=SQUARE, FWHM=FWHM, XC=XC, YC=YC, DX=DX, DY=DY, wavelength=wavelength
 
                

        m_time  =fxpar(hHa, 'DATE')
        x_pixelscale=fxpar(hHa, 'CDELT2')
        y_pixelscale=fxpar(hHa, 'CDELT3')
        IF x_pixelscale eq 0. then x_pixelscale=0.16
        IF y_pixelscale eq 0. then y_pixelscale=0.16
	m_title ='FISS '+ STRING(wavelength*0.1, FORMAT='(F5.2)')+'nm '+m_time
	if not keyword_set(xc) then xc=fxpar(hHa, 'TEL_XPOS')
	if not keyword_set(yc) then yc=fxpar(hHa, 'TEL_YPOS')
	if not keyword_set(dx) then dx=x_pixelscale
	if not keyword_set(dy) then dy=y_pixelscale
	if not keyword_set(wavelength) then wavelength=0.
        ;if keyword_set(fxpar(hHa, 'REFWV')) then wavelength=fxpar(hHa, 'REFWV')



        centerpx=where(abs(wlha-wavelength) eq min(abs(wlha-wavelength)))
	
	CDELT1=fxpar(hHa, 'CDELT1');angstrom per pixel.

	IF KEYWORD_SET(FWHM) THEN BEGIN
		FWHM1=abs(FWHM/CDELT1)
		kernel=gaussian_function(FWHM1, WIDTH=n_elements(im[*, 0, 0]), /NORMALIZE)
		
		kernel=shift(kernel, centerpx-n_elements(im[*, 0, 0])/2.)
		;sample=replicate(1., n_elements(im[0, *, 0]))##kernel
			
		FOR k=0, n_elements(im[0, 0, *])-1 DO $
			im[*, *, k]=im[*, *, k]*(replicate(1., n_elements(im[0, *, k]))##kernel)
		im1=total(im, 1)
	ENDIF ELSE BEGIN
		im1=reform(im[centerpx, *, *])
	ENDELSE
        im2=im1
        IF KEYWORD_SET(SQUARE) THEN BEGIN
                sz=size(reform(im1), /DIMENSION)
                im2=FLTARR(max(sz), max(sz))
                xrange=(ROUND(max(sz)-sz[0])/2.)+[0., sz[0]-1]
                yrange=(ROUND(max(sz)-sz[1])/2.)+[0., sz[1]-1]
                im2[xrange[0]:xrange[1], yrange[0]:yrange[1]]=im1
        ENDIF
	return, make_map(reform(im2), dx=dx, dy=dy, xc=xc, yc=yc, title=m_title, TIME=m_time)
end


pro fiss2map, filename,  map,wv=wv, xc=xc, yc=yc, dx=dx, dy=dy, pca=pca, FWHM=FWHM, ROTNSHIFT=ROTNSHIFT, SQUARE=SQUARE, ENLARGE=ENLARGE
	
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


	im=fiss_readfits_y(filename, wlha, hHa, pca=pca, rotnshift=rotnshift, ENLARGE=ENLARGE, /FOR_MAPSTRUCTURE)
        fissmaparr=!NULL
        FOR i=0, N_ELEMENTS(wv)-1 DO BEGIN
                im1=im
                fissmap1=make_fissmap(im1, wlha, hHa, SQUARE=SQUARE, FWHM=FWHM, xc=xc, yc=yc, dx=dx, dy=dy, wavelength=wv[i])
                fissmaparr=[fissmaparr, fissmap1]
;                stop
        ENDFOR

        map=fissmaparr

end
