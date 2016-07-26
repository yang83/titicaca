pro rot_pix, x, y, angle, return_x, return_y, CENTER=CENTER

		IF N_ELEMENTS(x) ne N_ELEMENTS(y) THEN BEGIN
			PRINT, 'X and Y numbers are different.'
			RETURN
		ENDIF
		x1=x & y1=y
		IF KEYWORD_SET(CENTER) THEN BEGIN
			x1=x1-CENTER[0]
			y1=y1-CENTER[1]
		ENDIF
		return_x=cos(angle*!pi/180.)*x1+sin(angle*!pi/180.)*y1
		return_y=-sin(angle*!pi/180.)*x1+cos(angle*!pi/180.)*y1
		IF KEYWORD_SET(CENTER) THEN BEGIN
			return_x=return_x+CENTER[0]
			return_y=return_y+CENTER[1]
		ENDIF
end

	
