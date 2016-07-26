function fiss_rot, image, angle, imsize

;Purpose : to rotate 3d cube fiss dataset in image direction.

        IF n_elements(size(image, /DIMENSION))	eq 2 THEN BEGIN
		sizeof1=SIZE(image, /DIMENSION)
		sizeof2=[imsize, imsize]
		image2=FLTARR(sizeof2)
		x_start	=(sizeof2[0]-sizeof1[0])/2.
		y_start	=(sizeof2[1]-sizeof1[1])/2.
		x_end	=x_start+sizeof1[0]-1
		y_end	=y_start+sizeof1[1]-1
	
		image2[x_start:x_end, y_start:y_end]=image

		return, rot(REFORM(image2), angle[0], /INTERP)
        ENDIF

	IF N_PARAMS() eq 3 then begin
		sizeof1=SIZE(image, /DIMENSION)
		sizeof2=[sizeof1[0], imsize, imsize]
		image2=FLTARR(sizeof2)
		x_start	=(sizeof2[1]-sizeof1[1])/2.
		y_start	=(sizeof2[2]-sizeof1[2])/2.
		x_end	=x_start+sizeof1[1]-1
		y_end	=y_start+sizeof1[2]-1
		image2[*, x_start:x_end, y_start:y_end]=image

        ENDIF else begin
                image2=image
        endelse
	
        FOR i=0, N_ELEMENTS(image2[*, 0, 0])-1 do $
                image2[i, *, *]=rot(REFORM(image2[i, *, *]), angle[0], /INTERP, /CUBIC)
	

	RETURN, image2
end


