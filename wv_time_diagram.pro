function img_extend_im, YAXIS, DATA, NEW_XAXIS=NEW_XAXIS, NEW_YAXIS=NEW_YAXIS, OVERFLOW_VALUE=OVERFLOW_VALUE
	;TIME AXIS EXTENDING
        
        YAXIS1=[YAXIS, max(YAXIS)+median(YAXIS-shift(YAXIS, 1))]
	
	NEW_YAXIS=FINDGEN(max(YAXIS1)-min(YAXIS1)-1)+min(YAXIS1)
	NEW_DATA=FLTARR(N_ELEMENTS(DATA[*, 0]), N_ELEMENTS(NEW_YAXIS))

	nT=0.
	medianYaxis=median(YAXIS-shift(YAXIS, 1))
	FOR i=0, n_elements(NEW_YAXIS)-1 DO BEGIN
		IF NEW_YAXIS[i] lt YAXIS1[nT+1] THEN BEGIN
;			IF NEW_YAXIS[i]-YAXIS1[nT] LT medianYaxis+2 THEN $
				NEW_DATA[*, i]=DATA[*, nT] 
		ENDIF ELSE BEGIN
			nT=nT+1
			NEW_DATA[*, i]=DATA[*, nT]	
		ENDELSE
	ENDFOR
;stop
	
	return, NEW_DATA
end

function img_extend_time, YAXIS, DATA, NEW_XAXIS=NEW_XAXIS, NEW_YAXIS=NEW_YAXIS, OVERFLOW_VALUE=OVERFLOW_VALUE
        IF NOT KEYWORD_SET(OVERFLOW_VALUE) THEN OVERFLOW_VALUE=1.5
	;TIME AXIS EXTENDING
	YAXIS1=[YAXIS, max(YAXIS)+median(YAXIS-shift(YAXIS, 1))]
	
	NEW_YAXIS=FINDGEN(max(YAXIS1)-min(YAXIS1)-1)+min(YAXIS1)
	NEW_DATA=FLTARR(N_ELEMENTS(DATA[*, 0]), N_ELEMENTS(NEW_YAXIS))

	nT=0.
	medianYaxis=median(YAXIS-shift(YAXIS, 1))
	FOR i=0, n_elements(NEW_YAXIS)-1 DO BEGIN
		IF NEW_YAXIS[i] lt YAXIS1[nT+1] THEN BEGIN
			IF NEW_YAXIS[i]-YAXIS1[nT] LT medianYaxis*OVERFLOW_VALUE THEN $
				NEW_DATA[*, i]=DATA[*, nT] 
		ENDIF ELSE BEGIN
			NEW_DATA[*, i]=DATA[*, nT]	
                        nT=nT+1
	        ENDELSE 
	ENDFOR


	return, NEW_DATA
end



function make_map_here_im, XAXIS, YAXIS, DATA, TITLE=title1, OVERFLOW_VALUE=OVERFLOW_VALUE

	DATA1=img_extend_im(YAXIS*100, DATA, NEW_YAXIS=NEW_YAXIS, OVERFLOW_VALUE=OVERFLOW_VALUE)
	YAXIS1=NEW_YAXIS/100.
	dx=median(abs(XAXIS-shift(XAXIS, 1)))
	dy=median(abs(YAXIS1-shift(YAXIS1, 1)))
	xc=XAXIS[round(n_elements(XAXIS)/2.)]
	yc=YAXIS1[round(n_elements(YAXIS1)/2.)]
	IF N_ELEMENTS(XAXIS) eq 502 THEN DATA1=rotate(DATA1, 5)
	
	return, make_map(DATA1, XC=xc, YC=yc, DX=dx, DY=dy, XUNIT='Angstrom', YUNIT='Pixel', TITLE=title1)
end

function make_map_here_time, XAXIS, YAXIS, DATA, TITLE=title1, OVERFLOW_VALUE=OVERFLOW_VALUE

	DATA1=img_extend_time(YAXIS, DATA, NEW_YAXIS=NEW_YAXIS, OVERFLOW_VALUE=OVERFLOW_VALUE)
	YAXIS1=NEW_YAXIS
	dx=median(abs(XAXIS-shift(XAXIS, 1)))
	dy=median(abs(YAXIS1-shift(YAXIS1, 1)))
	xc=XAXIS[round(n_elements(XAXIS)/2.)]
	yc=YAXIS1[round(n_elements(YAXIS1)/2.)]
	IF N_ELEMENTS(XAXIS) eq 502 THEN DATA1=rotate(DATA1, 5)
	return, make_map(DATA1, XC=xc, YC=yc, DX=dx, DY=dy, XUNIT='Angstrom', YUNIT='Time', TITLE=title1)
end

function wv_time_diagram, XAXIS, YAXIS, DATA, TITLE=TITLE, SPACE=SPACE, OVERFLOW_VALUE=OVERFLOW_VALUE
	IF KEYWORD_SET(SPACE) THEN $
		return, make_map_here_im(XAXIS, YAXIS, DATA, TITLE=TITLE, OVERFLOW_VALUE=OVERFLOW_VALUE) $
	ELSE $
		return, make_map_here_time(XAXIS, YAXIS, DATA, TITLE=TITLE, OVERFLOW_VALUE=OVERFLOW_VALUE)
end

	








	
