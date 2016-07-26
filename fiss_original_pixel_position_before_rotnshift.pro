function fiss_original_pixel_position_before_rotnshift, FILENAME, PIX_X, PIX_Y, MAGNIFY=MAGNIFY
        ;PIX_X, PIX_Y : pixel position in map data. after rotnshift

        IF NOT KEYWORD_SET(MAGNIFY) THEN MAGNIFY=1.

        h=headfits(FILENAME)
        size1           =       float(FXPAR(h, 'NAXIS2'))
        size2           =       float(FXPAR(h, 'NAXIS3'))
        
;        XPOS            =       FLOAT(FXPAR(h, 'TEL_XPOS'))/0.16
;        YPOS            =       FLOAT(FXPAR(h, 'TEL_YPOS'))/0.16
        ROT_ANGLE       =       FLOAT(fxpar(h, 'ROTANGLE'))
 

        CENTER          =       [1.,1.]*(size1>size2)*MAGNIFY/2.

        ROT_PIX, PIX_X, PIX_Y, -ROT_ANGLE, DROT_XPOS, DROT_YPOS, CENTER=CENTER

        RET_XPOS        =       DROT_XPOS+size1/2.-(size1>size2)*MAGNIFY/2.
        RET_YPOS        =       DROT_YPOS+size2/2.-(size1>size2)*MAGNIFY/2.

        RETURN, [[RET_XPOS], [RET_YPOS]]
end
