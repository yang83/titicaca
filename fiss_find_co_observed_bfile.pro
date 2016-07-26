function fiss_find_co_observed_bfile, afile, bfile
	
	a_time=fltarr(n_elements(afile))

	for i=0, n_elements(afile)-1 do begin
		hdrdate2julianday, fxpar(headfits(afile[i]), 'DATE'), yearA, monthA, dayA, hours=hoursA
	a_time[i]=hoursA
	endfor

	b_time=fltarr(n_elements(bfile))
	for i=0, n_elements(bfile)-1 do begin
		hdrdate2julianday, fxpar(headfits(bfile[i]), 'DATE'), yearB, monthB, dayB, hours=hoursB
		b_time[i]=hoursB
	endfor

	new_bfile=STRARR(n_elements(afile))
	for i=0, n_elements(a_time)-1 do begin
			m_diff=abs(a_time[i]-b_time)
			if abs(min(m_diff)) gt 2 then new_bfile[i]=' ' $
			else new_bfile[i]=bfile[where(m_diff eq min(m_diff))]
	endfor

	return, new_bfile
end
