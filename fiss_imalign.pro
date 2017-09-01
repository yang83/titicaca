function sample_im, image, nxs, nys, posx=posx, posy=posy, WIDTH=WIDTH
	if not keyword_set(WIDTH) then WIDTH=30.
	if not keyword_set(posx) then posx=nxs/2
	if not keyword_set(posy) then posy=nys/2
	
	posx=posx>WIDTH
	posy=posy>WIDTH
	posx=posx<(nxs-WIDTH-1)
	posy=posy<(nys-WIDTH-1)

	testim=reform(median(image(1:50,*, * ), dimension=1))

	sizeofim=size(testim, /DIMENSION)
	centermedian=median(testim[sizeofim[0]*0.4:sizeofim[0]*0.6, sizeofim[1]*0.4:sizeofim[1]*0.6])
	centerstddev=stddev(testim[sizeofim[0]*0.4:sizeofim[0]*0.6, sizeofim[1]*0.4:sizeofim[1]*0.6])
	
;	testim[where(testim lt centermedian-centerstddev*10)]=centermedian
	if total(testim lt 10) ne 0. then begin
		tt=where(testim lt 10) 
		testim[tt]=centermedian+randomu(seed, n_elements(tt))*500.-250.
	endif
	return, testim[posx-WIDTH:posx+WIDTH, -WIDTH+posy:WIDTH+posy]
end

pro fiss_imalign, inputfile, NOFITS=NOFITS, first=first, posx=posx, posy=posy, WINDOW_SIZE=WINDOW_SIZE, POS_SET_ZERO=POS_SET_ZERO, ROT_ANGLE_INFORMATION=angle, REFERENCE_FILE=REFERENCE_FILE, REFERENCE_ROT_ANGLE=REFERENCE_ROT_ANGLE, OFFSET_INFORMATION;, referencefile


;fits : to make fits file. if the keyword is not set, just jpg file generate.
;first : to align with first image
;Oct 16 2013 H. Yang : variable added. - OFFSET_INFORMATION
;Jun 25 2014 H. Yang : mod_slitdata_missing function used.



if not keyword_set(WINDOW_SIZE) then WINDOW_SIZE=30.
if keyword_set(REFERENCE_FILE) then m_ref_file=REFERENCE_FILE else m_ref_file=inputfile[0]
IF NOT KEYWORD_SET(REFERENCE_ROT_ANGLE) THEN $
	REFERENCE_ROT_ANGLE=angle[WHERE(STRCMP(inputfile, REFERENCE_FILE) eq 1)>0]

	OFFSET_X=0. & OFFSET_Y=0.

	t=mod_slitdata_missing(readfits(m_ref_file, h))
	alignsize=(size(t, /DIMENSION))[1]>(size(t, /DIMENSION))[2]
	image1		=	fiss_rot(float(t), REFERENCE_ROT_ANGLE, alignsize)
	ns			=	size(image1, /DIMENSION)
	nws			=	ns[0]
	nxs			=	ns[1]
	nys			=	ns[2]

	m_window	=	WINDOW_SIZE
	
	IF NOT KEYWORD_SET(POSX) THEN BEGIN
		window, xs=1024, ys=1024
		tvscl, image1[20, *, *]
		print, 'Click reference position.'
		cursor, x, y, /device
		posx=x & posy=y
		print, 'ref X:'+string(x)+' ref Y:'+string(y)
	ENDIF

	window, xs=1024, ys=1024
	sample1=sample_im(image1, nxs, nys, posx=posx, posy=posy, WIDTH=m_window) 
	nf=n_elements(inputfile)
	posx_n=posx & posy_n=posy

	tvscl, congrid(sample1, 50, 50), 0

	for i=0, nf-1 do begin
		image4		=	fiss_rot(float(mod_slitdata_missing(readfits(inputfile(i), h2))), angle[i], alignsize)
		ns			=	size(image4, /DIMENSION)
		nws			=	ns[0]
		nxs			=	ns[1]
		nys			=	ns[2]

	

	
	if keyword_set(POS_SET_ZERO) then begin
		posx_n=posx & posy_n=posy
	endif

	sample2=sample_im(image4, nxs, nys, posx=posx_n, posy=posy_n, WIDTH=m_window)
	shiftf=alignoffset(sample1, sample2)
	shiftx=shiftf[0]
	shifty=shiftf[1]
	posx_n=(posx_n-shiftx)
	posy_n=(posy_n-shifty)
	image4s=shift_sub3d(image4, 0., (-posx_n+posx), (-posy_n+posy))	
;stop	
	sample1s=sample_im(image1,  nxs, nys, posx=posx, posy=posy, WIDTH=m_window/2.)
	sample2s=sample_im(image4s,  nxs, nys, posx=posx, posy=posy, WIDTH=m_window/2.)
	shiftf=alignoffset(sample1s, sample2s)
	shiftx=shiftf[0]
	shifty=shiftf[1]
	posx_n=(posx_n-shiftx)
	posy_n=(posy_n-shifty)
	image4=shift_sub3d(image4, 0, (-posx_n+posx), (-posy_n+posy))
	
	tvscl, congrid(sample2s, 50, 50), i 
	

	namesplit=strsplit(inputfile(i), '.', /EXTRACT)
	write_png, namesplit(0)+'s.png', bytscl(reform(image4(20, *, *)))
;stop
	if not keyword_set(first) then image1=image4
	print, 'shift x :', (-posx_n+posx), ' y :', (-posy_n+posy), '(', i, '/', nf, ')'
	OFFSET_X=[OFFSET_X, -posx_n+posx] & OFFSET_Y=[OFFSET_Y, -posy_n+posy]
endfor

OFFSET_INFORMATION=[[OFFSET_X[1:*]], [OFFSET_Y[1:*]]]


end
