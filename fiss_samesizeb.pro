pro fiss_samesizeb, fB, shiftx


	FOR i=0, N_ELEMENTS(fB)-1 DO BEGIN
		imB=readfits(fB[i], h)
		szb=SIZE(imB, /DIMENSION)
		if szb[1] eq 250 then begin
			imB_new=INTARR(szb[0], 256, szb[2])
			imB_new[*, 0:249, *]=imB
			imB_new=shift(imB_new, 0, shiftx, 0)
		endif else begin	
			if i eq 0 then begin
				yesno=' '
				while not (strmatch('yes', yesno)||strmatch('no', yesno)) do begin
					read, 'Do you really want to shift Image B?(yes/no):', yesno
					if strmatch('no', yesno) then return $
					else if strmatch('yes', yesno) then continue
				endwhile		
			endif
			imB_new=shift(imB, 0, shiftx, 0)
		endelse
		writefits, fB[i], imB_new, h
	ENDFOR
end

	
