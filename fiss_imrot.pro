


pro fiss_imrot, fileArr, referenceangle=referenceangle, referencetime=referencetime, referencefile=referencefile, ANGLE_INFORMATION
;fiss field of view is rotate along the time. a hour matches to 15 degrees.
;if you put a bundle of file names, the program will make files which names are added '_r'.
;
;input : 
;	fileArr 		: file names array
;	referencefile 	: reference rotation file name
;	referencetime	: reference time in hour unit.
;	FIELD_SIZE			: image size extension to cover the edge of the image.
;	ENLARGE			: enlarge the image. in for 2X, you can give 
;output :
;	fileArr+'r' files are generated.
;	ANGLE_INFORMATION : return an array which contains rotation angle in degree.
;Modification
;	16 Oct 2013 H. Yang : NOPNG keyword added. 
;						  RETURN_IMAGE variable added.

var_rotAngleA=!NULL
if not keyword_set(FIELD_SIZE) then FIELD_SIZE=1
if not keyword_set(ENLARGE) then ENLARGE=1
fA=fileArr
if keyword_set(referencefile) then begin
	;image_ref=fiss_readfits_heesu(referencefile, wl, h, /no_wvcalib)
	time_ref=fxpar(headfits(referencefile), 'DATE')
	timeAhour_reference=mkDATEtoFTime(time_ref)/3600.
endif
if keyword_set(referencetime) then timeAhour_reference=referencetime ;else timeAhour_reference=17.2272;8.616+12 before 2012
if keyword_set(referenceangle) then begin
	if not keyword_set(referencefile) then begin
		print, 'Reference File is not supplied.'
		print, 'Reference angle and file should be given together.'
		return
	endif
	timeAhour_reference=timeAhour_reference-referenceangle/15.
endif


;==========================================================
;========================calc=====================
;==========================================================

	FOR i=0, N_ELEMENTS(fA)-1 DO BEGIN
		timeA=fxpar(headfits(fA[i]), 'DATE')
		timeAhour=mkDATEtoFTime(timeA)/3600.
		rotAngleA=(timeAhour-timeAhour_reference)*15.
		var_rotAngleA=[var_rotAngleA, rotAngleA]
	ENDFOR
	ANGLE_INFORMATION=var_rotAngleA
	RETURN

end
