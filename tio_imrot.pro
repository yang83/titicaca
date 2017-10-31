

pro tio_imrot, fileArr, reference_angle=reference_angle, reference_file=reference_file, angle
;fiss field of view is rotate along the time. a hour matches to 15 degrees.
;
;input : 
;	fileArr 		: file names array
;	referencefile 	: reference rotation file name
;output :
;	angle : returned
; 2017.10.27 : Modified from tio_imrot.pro.bak2013, H., Yang.


fA=fileArr
if keyword_set(reference_file) && keyword_set(reference_angle) then begin
	h=headfits(reference_file)
	time_ref=fxpar(h, 'DATE-OBS')+'T'+fxpar(h, 'TIME-OBS')
        timeA_reference=mkDATEtoFTime(time_ref)
	timeAhour_reference=timeA_reference/3600.-reference_angle/15.
endif else begin
        return
endelse

rotAngleA=!NULL
for i=0, n_elements(fA)-1 do begin
        h=headfits(fA[i])
        timeA=fxpar(h, 'DATE-OBS')+'T'+fxpar(h, 'TIME-OBS')
        timeAsec=mkDATEtoFTime(timeA)
        timeAhour=timeAsec/3600.

        rotAngle=(timeAhour-timeAhour_reference)*15.
        rotAngleA=[rotAngleA, rotAngle[0]]
        
        
endfor
angle=rotAngleA
end
