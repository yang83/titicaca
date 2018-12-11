function fiss_readfits_y, filename, wl, h, pca=pca, no_wvcalib=no_wvcalib, rotnshift=rotnshift, MAGNIFY=MAGNIFY, ENLARGE=ENLARGE, FOR_MAPSTRUCTURE=FOR_MAPSTRUCTURE

;2012 H. YANG
;2014 11 03 H. YANG NO_WVCALIB keyword modified.
;2015 1 22 H. Yang X_PIXELSIZE, Y_PIXELSIZE added.
;2016 Jul 26 H. Yang function name changed from 'fiss_readfits_heesu' to 'fiss_readfits_y'

  if not Keyword_set(MAGNIFY) THEN MAGNIFY=1.
  IF NOT KEYWORD_SET(ENLARGE) THEN ENLARGE=1.
  if strmatch(filename, '*_c.fts') then pca=1
  if keyword_set(pca) then begin
            image2=pca_read_heesu(filename, wl, h)
	    nz=n_elements(image2(*, 0,0))
	    nx=n_elements(image2(0, *, 0))
	    ny=n_elements(image2(0, 0, *))
	    image=image2;fltarr(nz, ny, nx)
	;for i=0, nz-1 do image(i, *, *)=reform(image2(i, *, *))

 endif else begin
		image=readfits(filename, h)
  endelse

 sizeof=size(image, /DIMENSION)
 image=congrid(image, sizeof[0], sizeof[1]*MAGNIFY, sizeof[2]*MAGNIFY)
 sizeof=size(image, /DIMENSION)

  wvband1  =   fxpar(h, 'WAVELEN')
  nw      =   fxpar(h, 'NAXIS1')
  wvband  =   (strsplit(wvband1, '.', /extract))[0]
  refx='0'
  wwc		= fxpar(h, 'CRPIX1')
  dldw		= fxpar(h, 'CDELT1');CDELT1 : wvlength angstrom/pixel
  wl=(findgen(nw)-wwc)*dldw

if not keyword_set(no_wvcalib) then begin
;        fiss_conf_wvcalib_v2, filename, wvband, refx, dldw, wwc, wvcen
        if wvband eq '6562' then begin
                fiss_wv_calib, '6562', total(total(image, 3), 2), wvpar1, method=0
                wl=(findgen(512)-wvpar1[0])*wvpar1[1]+wvpar1[2]-6562.817d0
        endif else begin
            if wvband eq '8542' then begin
                fiss_wv_calib, '8542', total(total(image, 3), 2), wvpar1, method=0
                wl=(findgen(502)-wvpar1[0])*wvpar1[1]+wvpar1[2]-8542.09d0
            endif
        endelse
endif

if keyword_set(rotnshift) then begin
        path=file_dirname(filename)
        basename=file_basename(filename)
        ref_basename=fxpar(h, 'ALGN_REF')

        ref_h=headfits(file_search(path, ref_basename))
        ref_xpos=fxpar(ref_h, 'TEL_XPOS')
        ref_ypos=fxpar(ref_h, 'TEL_YPOS')

	rot_angle=fxpar(h, 'ROTANGLE')

	image3=fiss_rot(float(image), rot_angle, round((sizeof[1]>sizeof[2])*ENLARGE))

;	x_shift=fxpar(h, 'YSHIFT_X')
;	y_shift=fxpar(h, 'YSHIFT_Y')


        X_PIXELSIZE=fxpar(h, 'CDELT2')
        Y_PIXELSIZE=fxpar(h, 'CDELT3')
        IF X_PIXELSIZE eq 0. THEN X_PIXELSIZE=0.16; for fiss pixel size
        IF Y_PIXELSIZE eq 0. THEN Y_PIXELSIZE=0.16
        xpos=fxpar(h, 'TEL_XPOS')
        ypos=fxpar(h, 'TEL_YPOS')
        x_shift=(xpos-ref_xpos)/X_PIXELSIZE
        y_shift=(ypos-ref_ypos)/Y_PIXELSIZE
        IF NOT KEYWORD_SET(FOR_MAPSTRUCTURE) THEN image3=shift_sub3d(image3, 0., x_shift*MAGNIFY, y_shift*MAGNIFY)
endif else begin
	image3=image
endelse

  ;wc=fxpar(h, 'CRPIX1')
  ;dldw=fxpar(h, 'CDELT1')

  return, image3
end
