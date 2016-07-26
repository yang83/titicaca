FUNCTION PIX2ASC, PIXEL_POST, MAP_STRUCTURE

	;PURPOSE : To know asc value in the map structure
        ;INPUT : 	PIXEL_POST - 2 components array.
	;			MAP_STRUCTURE - map data.
        ;OUTPUT : Return the Asc value of the map structure. 
        ;


	dx=MAP_STRUCTURE.DX & dy=MAP_STRUCTURE.DY
	xc=MAP_STRUCTURE.XC & yc=MAP_STRUCTURE.YC
	imsize=SIZE(MAP_STRUCTURE.DATA, /DIMENSION)

	R_PIXEL_POS=[0., 0.]
        IF N_ELEMENTS(PIXEL_POST) eq 2 THEN $
            PIXEL_POST2  =       [[PIXEL_POST[0], 0, 0], [PIXEL_POST[1], 0, 0]]


	FOR i=0, N_ELEMENTS(PIXEL_POST2)/2.-1 DO $
		R_PIXEL_POS= [[R_PIXEL_POS], [reform((PIXEL_POST2[i, *]-imsize/2.)*[dx, dy]+[xc, yc])]]
	
	s=size(R_PIXEL_POS, /DIMENSION)
	R_PIXEL_POS2=FLTARR(s[1], s[0])
	R_PIXEL_POS2[*, 0]=R_PIXEL_POS[0, *]
	R_PIXEL_POS2[*, 1]=R_PIXEL_POS[1, *]
;        IF N_ELEMENTS(PIXEL_POST) eq 2 THEN $
;            R_PIXEL_POS2=R_PIXEL_POS2[*, N_ELEMENTS(R_PIXEL_POS2[0, *])-1-2]
        IF N_ELEMENTS(PIXEL_POST) eq 2 THEN RETURN, REFORM(R_PIXEL_POS2[1, *])

        return, R_PIXEL_POS2[1:*, *]

END
