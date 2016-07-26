function mkdatetoftime, strt

ret_timeAsec=0.
FOR i=0, N_ELEMENTS(strt)-1 DO BEGIN
	if strmatch(strt[i], '*T*') then temp=strsplit(strt[i], 'T', /EXTRACT) $	
	else if strmatch(strt[i], '* *') then temp=strsplit(strt[i], ' ', /EXTRACT) $
	else temp=[' ', strt[i]]
	strt[i]=temp[1]

 	timeAsplit=strsplit(strt[i], ':', /EXTRACT)
 	timeAsec=float(timeAsplit[0])*60.*60.+float(timeAsplit[1])*60.+ float(timeAsplit[2])
	ret_timeAsec=[ret_timeAsec, timeAsec]
	
ENDFOR
return, ret_timeAsec[1:*]

	
end
